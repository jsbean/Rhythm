//
//  Tempo.Interpolation.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/11/17.
//
//

import Collections
import ArithmeticTools

public extension Tempo {

    public struct Collection: DuratedContainer {

        public typealias Storage = SortedDictionary<Fraction, Interpolation.Fragment>

        public let elements: Storage

        public init(_ elements: Storage) {
            self.elements = elements
        }

        public init <S> (_ elements: S)
            where S: Sequence, S.Iterator.Element == Interpolation.Fragment
        {
            self = Builder().add(elements).build()
        }

        public init <S> (_ elements: [Interpolation])
            where S: Sequence, S.Iterator.Element == Interpolation
        {
            self.init(elements.map { Interpolation.Fragment($0) })
        }

        /// - FIXME: Use `Seconds` instead of `Double`
        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            assert(contains(metricalOffset))
            let index = indexOfElement(containing: metricalOffset)!
            let (globalOffset, interpolation) = elements[index]
            let internalOffset = metricalOffset - globalOffset
            let localSeconds = interpolation.secondsOffset(for: internalOffset)
            return secondsOffset(at: index) + localSeconds
        }

        public func secondsOffset(at index: Int) -> Double {
            assert(elements.indices.contains(index))
            return (0..<index)
                .lazy
                .map { self.elements[$0] }
                .map { _, interp in interp.duration }
                .sum
        }
    }
}

extension Tempo.Collection: Fragmentable {

    // FIXME: Decide assert or soft clipping out-of-range ranges
    public subscript (range: Range<Fraction>) -> Tempo.Collection {

        assert(range.lowerBound >= .unit)

        let range = range.upperBound > duration ? range.lowerBound ..< duration : range

        guard let startIndex = indexOfElement(containing: range.lowerBound) else {
            return .init([:])
        }
        let endIndex = (indexOfElement(containing: range.upperBound) ?? elements.count) - 1
        let start = element(from: range.lowerBound, at: startIndex)

        // Single interpolation
        if endIndex == startIndex {
            let (offset, element) = elements[startIndex]
            return Tempo.Collection([.unit: element[range.shifted(by: offset)]])
        }

        let end = element(to: range.upperBound, at: endIndex)

        // Two consecutive measure
        if endIndex == startIndex + 1 {
            return Builder().add([start,end]).build()
        }

        // Three or more measures
        let innards = elements(in: startIndex + 1 ... endIndex - 1)
        return Builder().add(start + innards + end).build()
    }

    private func elements(in range: CountableClosedRange<Int>) -> [Interpolation.Fragment] {
        return range
            .lazy
            .map { index in self.elements[index] }
            .map { _, meter in meter }
    }
}

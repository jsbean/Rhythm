//
//  Tempo.Interpolation.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/11/17.
//
//

import Collections
import ArithmeticTools

public extension Tempo.Interpolation {

    public struct Collection: MetricalDurationSpanningContainer {

        public typealias Storage = SortedDictionary<Fraction, Tempo.Interpolation.Fragment>

        public let base: Storage

        public init(_ base: Storage) {
            self.base = base
        }

        public init <S> (_ base: S)
            where S: Sequence, S.Iterator.Element == Tempo.Interpolation.Fragment
        {
            self = Builder().add(base).build()
        }

        public init <S> (_ elements: [Tempo.Interpolation])
            where S: Sequence, S.Iterator.Element == Tempo.Interpolation
        {
            self.init(elements.map { Tempo.Interpolation.Fragment($0) })
        }

        /// - FIXME: Use `Seconds` instead of `Double`
        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            assert(contains(metricalOffset))
            let index = indexOfElement(containing: metricalOffset)!
            let (globalOffset, interpolation) = base[index]
            let internalOffset = metricalOffset - globalOffset
            let localSeconds = interpolation.secondsOffset(for: internalOffset)
            return secondsOffset(at: index) + localSeconds
        }

        public func secondsOffset(at index: Int) -> Double {
            assert(base.indices.contains(index))
            return (0..<index)
                .lazy
                .map { self.base[$0] }
                .map { _, interp in interp.duration }
                .sum
        }
    }
}

extension Tempo.Interpolation.Collection: Fragmentable {

    // FIXME: Decide assert or soft clipping out-of-range ranges
    public subscript (range: Range<Fraction>) -> Tempo.Interpolation.Collection {

        assert(range.lowerBound >= .zero)

        let range = range.upperBound > length ? range.lowerBound ..< length : range

        guard let startIndex = indexOfElement(containing: range.lowerBound) else {
            return .init([:])
        }

        let endIndex = (indexOfElement(containing: range.upperBound) ?? base.count) - 1
        let start = element(from: range.lowerBound, at: startIndex)

        // Single interpolation
        if endIndex == startIndex {
            let (offset, element) = base[startIndex]
            // FIXME: Use `range.shifted(by:)`
            let range = offset ..< offset + element.range.length
            return Tempo.Interpolation.Collection([.zero: element[range]])
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

    private func elements(in range: CountableClosedRange<Int>) -> [Tempo.Interpolation.Fragment] {
        return range
            .lazy
            .map { index in self.base[index] }
            .map { _, meter in meter }
    }
}

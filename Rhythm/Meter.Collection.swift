//
//  Meter.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

extension Meter {

    public struct Collection: DuratedContainer {

        public let elements: SortedDictionary<Fraction, Meter.Fragment>

        public init(_ elements: SortedDictionary<Fraction, Meter.Fragment>) {
            self.elements = elements
        }
    }
}

extension Meter.Collection {

    subscript (range: Range<Fraction>) -> Meter.Collection {

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
            return Meter.Collection([.unit: element[range.shifted(by: offset)]])
        }

        let end = element(to: range.upperBound, at: endIndex)

        /// Two consecutive measures
        guard endIndex > startIndex + 1 else {
            return Builder().add([start,end]).build()
        }

        /// Three or more measures
        let innards = elements(in: startIndex + 1 ... endIndex - 1)
        return Builder().add(start + innards + end).build()
    }

    private func meters(in range: CountableClosedRange<Int>) -> [Meter.Fragment] {
        return range
            .lazy
            .map { index in self.elements[index] }
            .map { _, meter in meter }
    }

    private func elements(in range: CountableClosedRange<Int>) -> [Meter.Fragment] {
        return range
            .lazy
            .map { index in self.elements[index] }
            .map { _, meter in meter }
    }
}

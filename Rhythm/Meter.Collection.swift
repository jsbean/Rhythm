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
        let start = meterFragment(from: range.lowerBound, at: startIndex)

        /// Single measure
        guard endIndex > startIndex else {
            let (meterOffset, fragment) = elements[startIndex]
            return Meter.Collection([.unit: fragment[range.shifted(by: meterOffset)]])
        }

        let end = meterFragment(to: range.upperBound, at: endIndex)

        /// Two consecutive measures
        guard endIndex > startIndex + 1 else {
            return Builder().addMeters([start,end]).build()
        }

        /// Three or more measures
        let innards = meters(in: startIndex + 1 ... endIndex - 1)
        return Builder().addMeters(start + innards + end).build()
    }

    private func meters(in range: CountableClosedRange<Int>) -> [Meter.Fragment] {
        return range
            .lazy
            .map { index in self.elements[index] }
            .map { _, meter in meter }
    }

    private func meterFragment(from offset: Fraction, at index: Int) -> Meter.Fragment {
        let (meterOffset, fragment) = elements[index]
        return fragment.from(offset - meterOffset)
    }

    private func meterFragment(to offset: Fraction, at index: Int) -> Meter.Fragment {
        let (meterOffset, fragment) = elements[index]
        return fragment.to(offset - meterOffset)
    }
}

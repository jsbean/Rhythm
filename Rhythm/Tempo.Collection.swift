//
//  Tempo.Collection.swift
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
                .map { elements[$0] }
                .map { $1.duration }
                .sum
        }
    }
}

extension Tempo.Collection: Fragmentable {

    subscript (range: Range<Fraction>) -> Meter.Collection {
        fatalError()
    }
}

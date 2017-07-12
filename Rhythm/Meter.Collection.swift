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

        guard indexOfElement(containing: range.lowerBound) != nil else {
            return .init([:])
        }



        fatalError()
    }
}

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

    public struct Collection {

        private let storage: SortedDictionary<Fraction, Meter.Fragment>

        public init(_ storage: SortedDictionary<Fraction, Meter.Fragment>) {
            self.storage = storage
        }
    }
}

extension Meter.Collection: Fragmentable {

    subscript (range: Range<Fraction>) -> Meter.Collection {
        fatalError()
    }
}

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

    public struct Collection {

        public typealias Storage = SortedDictionary<Fraction, Interpolation.Fragment>

        private let elements: Storage

        public init(_ elements: Storage) {
            self.elements = elements
        }
    }
}

extension Tempo.Collection: Fragmentable {

    subscript (range: Range<Fraction>) -> Meter.Collection {
        fatalError()
    }
}

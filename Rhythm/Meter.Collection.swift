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

        public init<S>(_ elements: S) where S : Sequence, S.Iterator.Element == Meter.Fragment {
            self = Builder().add(elements).build()
        }

        public init <S: Sequence> (_ elements: S) where S.Iterator.Element == Meter {
            self.init(elements.map { Meter.Fragment($0) })
        }
    }
}

extension Meter.Collection: Equatable {

    public static func == (lhs: Meter.Collection, rhs: Meter.Collection) -> Bool {
        return lhs.elements == rhs.elements
    }
}

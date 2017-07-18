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

    public struct Collection: MetricalDurationSpanningContainer {

        public typealias Metric = Fraction

        public let base: SortedDictionary<Fraction,Meter.Fragment>

        public init(_ base: SortedDictionary<Fraction, Meter.Fragment>) {
            self.base = base
        }

        public init <S> (_ base: S) where S: Sequence, S.Iterator.Element == Meter.Fragment {
            self = Builder().add(base).build()
        }

        public init <S> (_ base: S) where S: Sequence, S.Iterator.Element == Meter {
            self.init(base.map(Meter.Fragment.init))
        }
    }
}

extension Meter.Collection: Equatable {

    public static func == (lhs: Meter.Collection, rhs: Meter.Collection) -> Bool {
        return lhs.base == rhs.base
    }
}

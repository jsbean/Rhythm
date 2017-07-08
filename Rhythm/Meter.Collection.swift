//
//  Meter.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/8/17.
//
//

import ArithmeticTools
import Collections

extension Meter {

    public struct Collection {

        public final class Builder {

            private var meters: SortedDictionary<Fraction, Meter.Fragment> = [:]
            private var offset: Fraction = .unit

            public init() { }

            public func addMeter(_ meter: Meter.Fragment) {
                self.meters.insert(meter, key: offset)
                offset += meter.range.length
            }

            public func addMeter(_ meter: Meter) {
                let fragment = Fragment(meter)
                self.meters.insert(fragment, key: offset)
                offset += fragment.range.length
            }

            public func build() -> Collection {
                return Collection(meters: meters)
            }
        }

        fileprivate let meters: SortedDictionary<Fraction, Meter.Fragment>

        public init(meters: SortedDictionary<Fraction, Meter.Fragment>) {
            self.meters = meters
        }
    }
}

extension Meter.Collection: AnyCollectionWrapping {

    public var collection: AnyCollection<(Fraction,Meter.Fragment)> {
        return AnyCollection(meters)
    }
}

// This is already in newer versions of dn-m/ArithemticTools over all Rational types
extension Fraction: SignedNumber {

    // MARK: - Signed Number
    /// Negate `Rational` type arithmetically.
    public static prefix func - (rational: Fraction) -> Fraction {
        return -rational
    }
}

extension ClosedRange where Bound: SignedNumber {

    public var length: Bound {
        return upperBound - lowerBound
    }
}

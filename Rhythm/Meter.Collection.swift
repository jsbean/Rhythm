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
                addMeter(fragment)
            }

            public func addMeters(_ meters: [Meter.Fragment]) {
                meters.forEach(addMeter)
            }

            public func build() -> Collection {
                return Collection(meters: meters)
            }
        }

        public static let empty = Collection(meters: [:])

        public var beatContexts: [BeatContext] {
            var result: [BeatContext] = []
            for (offset, fragment) in meters {
                let offset = offset.numerator /> offset.denominator
                let meterContext = Meter.Context(meter: fragment.meter, at: offset)

                // FIXME: Use Collection-based Range type
                // FIXME: In Swift 3.1 version, `Rational` is `Strideable`.
                // FIXME: Use CountableClosedRange
                // FIXME: Use `reduce` over countable closed range of `Fraction`.
                var beat = fragment.range.lowerBound
                while beat < fragment.range.upperBound {
                    let beatContext = BeatContext(
                        meterContext: meterContext,
                        offset: beat.numerator /> beat.denominator
                    )
                    result.append(beatContext)
                    beat += Fraction(1, beat.denominator)
                }
            }

            return result
        }

        public var length: Fraction {

            guard !isEmpty else {
                return .unit
            }

            // FIXME: Make `DictionaryType` a `BidirectionalCollection` in dn-m/Collections
            let (offset, fragment) = meters[meters.count - 1]
            return offset + fragment.range.length
        }

        public let meters: SortedDictionary<Fraction, Meter.Fragment>

        public init(meters: SortedDictionary<Fraction, Meter.Fragment>) {
            self.meters = meters
        }

        public init(_ meters: [Meter.Fragment]) {
            let builder = Builder()
            builder.addMeters(meters)
            self = builder.build()
        }

        public init(_ meters: [Meter]) {
            let builder = Builder()
            builder.addMeters(meters.map { Meter.Fragment($0) })
            self = builder.build()
        }

        public subscript (range: ClosedRange<Fraction>) -> Collection {

            guard let startIndex = indexOfMeter(containing: range.lowerBound) else {
                return .empty
            }

            let endIndex = indexOfMeter(containing: range.upperBound) ?? count - 1
            let start = meterFragment(from: range.lowerBound, at: startIndex)

            let builder = Builder()

            /// Single measure
            guard endIndex > startIndex else {
                let (meterOffset, fragment) = meters[startIndex]
                let newFragment = Meter.Fragment(
                    fragment.meter,
                    from: range.lowerBound - meterOffset,
                    to: range.upperBound - meterOffset
                )
                return Collection([newFragment])
            }

            let end = meterFragment(to: range.upperBound, at: endIndex)

            guard endIndex > startIndex + 1 else {
                builder.addMeters([start,end])
                return builder.build()
            }

            let innards = meters(in: startIndex + 1 ... endIndex - 1)
            builder.addMeters(start + innards + end)

            return builder.build()
        }

        public subscript (offset: Fraction) -> (Fraction, Meter.Fragment)? {
            guard let index = indexOfMeter(containing: offset) else { return nil }
            return meters[index]
        }

        public func indexOfMeter(containing offset: Fraction) -> Int? {
            let ranges = meters.map { offset, fragment in offset ... offset + fragment.length }
            return ranges.index { $0.contains(offset) }
        }

        private func subCollection(in range: ClosedRange<Int>) -> Collection {
            fatalError()
        }

        private func meterFragment(from offset: Fraction, at index: Int) -> Meter.Fragment {
            let (meterOffset, fragment) = meters[index]
            return Meter.Fragment(fragment.meter, from: offset - meterOffset)
        }

        private func meterFragment(to offset: Fraction, at index: Int) -> Meter.Fragment {
            let (meterOffset, fragment) = meters[index]
            return Meter.Fragment(fragment.meter, to: offset - meterOffset)
        }

        private func meters(in range: CountableClosedRange<Int>) -> [Meter.Fragment] {
            return range.map { index in meters[index].1 }
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

// FIXME: Move to dn-m/ArithmeticTools, make generic
public func - (lhs: ClosedRange<Fraction>, rhs: Fraction) -> ClosedRange<Fraction> {
    return lhs.lowerBound - rhs ... lhs.upperBound - rhs
}

public func + (lhs: ClosedRange<Fraction>, rhs: Fraction) -> ClosedRange<Fraction> {
    return lhs.lowerBound + rhs ... lhs.upperBound + rhs
}

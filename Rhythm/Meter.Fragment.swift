//
//  Meter.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/6/17.
//
//

import ArithmeticTools

extension Meter {

    public struct Fragment {

        public var beatOffsets: [Fraction] {
            let length = range.upperBound - range.lowerBound
            return (0..<length.numerator).map { beat in Fraction(beat, length.denominator) }
        }

        // FIXME: There are many assumptions being made here
        // Use zip, reduce, etc.
        public var meterContexts: [Meter.Context] {
            var result: [Meter.Context] = []
            var offset = range.lowerBound
            while offset < range.upperBound {
                let context = Context(meter: meter, at: offset.numerator /> offset.denominator)
                result.append(context)
                offset += Fraction(1, range.lowerBound.denominator)
            }
            return result
        }

        public var length: Fraction {
            return range.length
        }

        public let meter: Meter
        public let range: ClosedRange<Fraction>

        public init(_ meter: Meter, in range: ClosedRange<Fraction>) {
            self.meter = meter
            self.range = range
        }

        public init(
            _ meter: Meter,
            from start: Fraction = .unit,
            to end: Fraction? = nil
        )
        {
            let range = start ... (end ?? Fraction(meter))
            self.init(meter, in: range)
        }
    }
}

extension Meter.Fragment: Equatable {

    public static func == (lhs: Meter.Fragment, rhs: Meter.Fragment) -> Bool {
        return lhs.meter == rhs.meter && lhs.range == rhs.range
    }
}

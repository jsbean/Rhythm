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
            self.range = sanitized(range: range, for: meter)
            self.meter = meter
        }

        public init(
            _ meter: Meter,
            from start: Fraction = .unit,
            to end: Fraction? = nil
        )
        {
            let end = end ?? Fraction(meter)
            let range = start ... end
            self.init(meter, in: range)
        }
    }
}

func sanitized(range: ClosedRange<Fraction>, for meter: Meter) -> ClosedRange<Fraction> {
    let full = .unit ... Fraction(meter)
    let range = range.lowerBound.clamped(in: full) ... range.upperBound.clamped(in: full)
    return normalized(range: range, for: meter)
}

/// - Returns: Range which has a denominator >= to that of the given `meter`.
func normalized(range: ClosedRange<Fraction>, for meter: Meter) -> ClosedRange<Fraction> {

    // Ensure that the range is represented with the same denominator
    // FIXME: Use fixed `Ration.respelling(denominator:)`
    let common = lcm(range.lowerBound.denominator, range.upperBound.denominator)
    let start = respellingDenominator(of: range.lowerBound, to: common)!
    let end = respellingDenominator(of: range.upperBound, to: common)!

    guard start.denominator >= meter.denominator else {
        let start = respellingDenominator(of: start, to: meter.denominator)!
        let end = respellingDenominator(of: end, to: meter.denominator)!
        return start ... end
    }

    return start ... end
}

extension Meter.Fragment: Equatable {

    public static func == (lhs: Meter.Fragment, rhs: Meter.Fragment) -> Bool {
        return lhs.meter == rhs.meter && lhs.range == rhs.range
    }
}

// FIXME: Temporary wrapper to cover up bug: https://github.com/dn-m/ArithmeticTools/issues/110
func respellingDenominator <R: Rational> (of rational: R, to value: Int) -> R? {

    if rational.numerator == 0 {
        return R(0, value)
    }

    return rational.respelling(denominator: value)
}

//
//  Interpolation.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import ArithmeticTools

extension Interpolation {

    public struct Fragment: DuratedFragment {

        /// - FIXME: Use `Seconds` not `Double`
        public var duration: Double {
            let start = base.secondsOffset(for: range.lowerBound)
            let end = base.secondsOffset(for: range.upperBound)
            return end - start
        }

        public let base: Interpolation
        public let range: Range<Fraction>

        public init(_ interpolation: Interpolation, in range: Range<Fraction>) {
            self.base = interpolation
            self.range = range
        }

        /// - Returns: `Interpolation.Fragment` in the given `range`.
        public subscript (range: Range<Fraction>) -> Interpolation.Fragment {
            assert(range.lowerBound >= self.range.lowerBound)
            assert(range.upperBound <= self.range.upperBound)
            return Interpolation.Fragment(base, in: range)
        }

        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            return base.secondsOffset(for: metricalOffset)
        }
    }
}

extension Interpolation.Fragment {

    public init(_ interpolation: Interpolation) {
        self.base = interpolation
        self.range = .unit ..< interpolation.metricalDuration
    }
}

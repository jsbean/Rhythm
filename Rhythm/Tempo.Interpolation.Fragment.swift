//
//  Interpolation.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import ArithmeticTools

extension Tempo.Interpolation {

    public struct Fragment: DuratedFragment {

        public var duration: Double {
            let start = base.secondsOffset(for: range.lowerBound)
            let end = base.secondsOffset(for: range.upperBound)
            return end - start
        }

        public let base: Tempo.Interpolation
        public let range: Range<Fraction>

        public init(_ interpolation: Tempo.Interpolation, in range: Range<Fraction>) {
            self.base = interpolation
            self.range = range
        }

        /// - Returns: `Interpolation.Fragment` in the given `range`.
        public subscript(range: Range<Fraction>) -> Tempo.Interpolation.Fragment {
            assert(range.lowerBound >= self.range.lowerBound)
            assert(range.upperBound <= self.range.upperBound)
            return Tempo.Interpolation.Fragment(base, in: range)
        }

        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            return base.secondsOffset(for: metricalOffset)
        }
    }
}

extension Tempo.Interpolation.Fragment {

    public init(_ interpolation: Tempo.Interpolation) {
        self.base = interpolation
        self.range = .unit ..< interpolation.metricalDuration
    }
}

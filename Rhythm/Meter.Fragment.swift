//
//  Meter.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import ArithmeticTools

extension Meter {

    public struct Fragment: DuratedFragment {

        public let base: Meter
        public let range: Range<Fraction>

        // FIXME: Add range sanitation.
        public init(_ meter: Meter, in range: Range<Fraction>? = nil) {
            self.base = meter
            self.range = range ?? .unit ..< Fraction(meter)
        }

        /// - Warning: Not yet implemented!
        public subscript (range: Range<Fraction>) -> Meter.Fragment {
            fatalError()
        }
    }
}

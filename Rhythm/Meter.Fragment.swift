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

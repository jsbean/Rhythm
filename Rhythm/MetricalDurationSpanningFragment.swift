//
//  MetricalDurationSpanningFragment.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import ArithmeticTools

public protocol MetricalDurationSpanningFragment: SpanningFragment, MetricalDurationSpanning { }

extension MetricalDurationSpanningFragment where Fragment == Self, Metric == Fraction {

    func from(_ offset: Fraction) -> Self {
        assert(offset >= self.range.lowerBound)
        let range = offset ..< self.range.upperBound
        return self[range]
    }

    func to(_ offset: Fraction) -> Self {
        assert(offset <= self.range.upperBound)
        let range = self.range.lowerBound ..< offset
        return self[range]
    }
}

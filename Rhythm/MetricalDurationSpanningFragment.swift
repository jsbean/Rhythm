//
//  MetricalDurationSpanningFragment.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import ArithmeticTools

public protocol MetricalDurationSpanningFragment: Fragmentable {
    associatedtype Base: Fragmentable
    var base: Base { get }
    var range: Range<Fraction> { get }
}

extension MetricalDurationSpanningFragment where Fragment == Self {

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

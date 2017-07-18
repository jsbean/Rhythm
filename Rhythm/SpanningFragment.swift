//
//  SpanningFragment.swift
//  Rhythm
//
//  Created by James Bean on 7/18/17.
//
//

import ArithmeticTools

public protocol SpanningFragment: Spanning, Fragmentable {
    associatedtype Base: Fragmentable
    var base: Base { get }
    var range: Range<Metric> { get }
}

extension SpanningFragment {

    public var length: Metric {
        return range.length
    }
}

extension SpanningFragment where Fragment == Self {

    public func to(_ offset: Metric) -> Self {
        assert(offset <= self.range.upperBound)
        let range = self.range.lowerBound ..< offset
        return self[range]
    }

    public func from(_ offset: Metric) -> Self {
        assert(offset >= self.range.lowerBound)
        let range = offset ..< self.range.upperBound
        return self[range]
    }
}

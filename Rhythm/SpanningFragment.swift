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
    var range: Range<Fraction> { get }
}

extension SpanningFragment {

    public var length: Fraction {
        return range.length
    }
}

//extension SpanningFragment where Fragment == Self {
//
//    func from(_ offset: Fraction) -> Self {
//        assert(offset >= self.range.lowerBound)
//        let range = offset ..< self.range.upperBound
//        return self[range]
//    }
//
//    func to(_ offset: Fraction) -> Self {
//        assert(offset <= self.range.upperBound)
//        let range = self.range.lowerBound ..< offset
//        return self[range]
//    }
//}

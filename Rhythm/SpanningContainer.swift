//
//  SpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Collections
import ArithmeticTools

// FIXME: Move to dn-m/Collections
public protocol SpanningContainer: Fragmentable, Spanning {
    associatedtype Spanner: Fragmentable, Spanning
    var base: SortedDictionary<Spanner.Metric,Spanner> { get }
    init(_: SortedDictionary<Spanner.Metric,Spanner>)
    init <S> (_: S) where S: Sequence, S.Iterator.Element == Spanner
}

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
public protocol SpanningContainer: AnyCollectionWrapping, Fragmentable, Spanning {
    associatedtype Spanner: Fragmentable, Spanning
    var elements: SortedDictionary<Spanner.Metric,Spanner> { get }
    init(_: SortedDictionary<Spanner.Metric,Spanner>)
    init <S> (_: S) where S: Sequence, S.Iterator.Element == Spanner
}

extension SpanningContainer {

    // MARK: AnyCollectionWrapping

    public var collection: AnyCollection<(Spanner.Metric,Spanner)> {
        return AnyCollection(elements)
    }
}

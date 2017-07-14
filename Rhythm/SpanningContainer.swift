//
//  SpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Collections

// FIXME: Move to dn-m/Collections
public protocol SpanningContainer: AnyCollectionWrapping, Fragmentable, Spanning {
    associatedtype Spanner: Fragmentable, Spanning
    var elements: SortedDictionary<Spanner.Metric,Spanner> { get }
    init(_ elements: SortedDictionary<Spanner.Metric,Spanner>)
    init <S> (_ elements: S) where S: Sequence, S.Iterator.Element == Spanner
}

extension SpanningContainer {

    public var collection: AnyCollection<(Spanner.Metric,Spanner)> {
        return AnyCollection(elements)
    }
}

//
//  SpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Collections

// FIXME: Move to dn-m/Collections
public protocol SpanningContainer: Fragmentable {

    associatedtype Element: SpanningFragment

    var elements: SortedDictionary<Element.Metric,Element> { get }

    init(_ elements: SortedDictionary<Element.Metric,Element>)

    init <S> (_ elements: S) where S: Sequence, S.Iterator.Element == Element
}

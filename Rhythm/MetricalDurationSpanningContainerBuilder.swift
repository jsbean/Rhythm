//
//  MetricalDurationSpanningContainerBuilder.swift
//  Rhythm
//
//  Created by James Bean on 7/14/17.
//
//

import Collections
import ArithmeticTools

public protocol MetricalDurationSpanningContainerBuilder: SpanningContainerBuilder {
    associatedtype Product: MetricalDurationSpanningContainer
    var offset: Fraction { get set }
}

// FIXME: Constraints should not be necessary
extension MetricalDurationSpanningContainerBuilder where
    Product.Metric == Product.Spanner.Metric,
    Product.Metric == Fraction
{

    @discardableResult public func add(_ element: Spanner) -> Self {
        self.intermediate.insert(element, key: offset)
        offset += element.range.length
        return self
    }

    @discardableResult public func add <S: Sequence> (_ elements: S) -> Self
        where S.Iterator.Element == Spanner
    {
        elements.forEach { _ = add($0) }
        return self
    }
}

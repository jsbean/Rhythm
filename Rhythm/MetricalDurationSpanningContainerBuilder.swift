//
//  MetricalDurationSpanningContainerBuilder.swift
//  Rhythm
//
//  Created by James Bean on 7/14/17.
//
//

import Collections
import ArithmeticTools

public protocol MetricalDurationSpanningContainerBuilder: SpanningContainerBuilder { }

// FIXME: Constraints should not be necessary
extension MetricalDurationSpanningContainerBuilder where
    Product.Metric == Product.Spanner.Metric,
    Product.Metric == Fraction
{

    /// Adds the given `element` to the `intermediate` with accumulativng offsets.
    ///
    /// - Returns: `Self`.
    ///
    // FIXME: This should be able to be abstracted to `SpanningContainerBuilder`.
    @discardableResult public func add(_ element: Spanner) -> Self {
        self.intermediate.insert(element, key: offset)
        offset += element.range.length
        return self
    }
}

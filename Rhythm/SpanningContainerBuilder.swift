//
//  SpanningContainerBuilder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

/// Interface for types which can build `SpanningContainer` types.
public protocol SpanningContainerBuilder: class {

    // MARK: - Associated Types

    /// Type of product which is built by `SpanningContainerBuilder`.
    associatedtype Product: SpanningContainer

    /// Spanner-type contained by the `Product`.
    typealias Spanner = Product.Spanner

    // MARK: - Instance Properties

    /// Intermediate storage which is converted into the `Product`.
    var intermediate: SortedDictionary<Spanner.Metric,Spanner> { get set }

    // MARK: - Instance Methods

    /// Adds the given `Spanner` to the `intermediate`.
    func add(_: Spanner) -> Self

    /// Creates the final `Product`.
    func build() -> Product
}

extension SpanningContainerBuilder {

    /// Creates the final `Product` with the `intermediate`.
    public func build() -> Product {
        return Product(intermediate)
    }
}

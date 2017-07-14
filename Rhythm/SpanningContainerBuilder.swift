//
//  SpanningContainerBuilder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

public protocol SpanningContainerBuilder: class {
    associatedtype Product: SpanningContainer
    typealias Spanner = Product.Spanner
    var intermediate: SortedDictionary<Spanner.Metric,Spanner> { get set }
    func add(_: Spanner) -> Self
}

extension SpanningContainerBuilder {

    public func build() -> Product {
        return Product(intermediate)
    }
}

//
//  Builder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

public protocol SpanningContainerBuilder: class {
    associatedtype Product: SpanningContainer
    typealias Element = Product.Element
    var intermediate: SortedDictionary<Element.Metric,Element> { get set }
    func add(_: Element) -> Self
}

extension SpanningContainerBuilder {

    public func build() -> Product {
        return Product(intermediate)
    }
}

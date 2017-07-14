//
//  Builder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

protocol SpanningContainerBuilder: class {
    associatedtype Product: MetricalDurationSpanningContainer
    typealias Element = Product.Element
    var intermediate: SortedDictionary<Fraction,Element> { get set }
    var offset: Fraction { get set }
    func add(_: Element) -> Self
}

extension SpanningContainerBuilder {

    @discardableResult public func add(_ element: Element) -> Self {
        self.intermediate.insert(element, key: offset)
        offset += element.range.length
        return self
    }

    @discardableResult public func add <S: Sequence> (_ elements: S) -> Self
        where S.Iterator.Element == Element
    {
        elements.forEach { _ = add($0) }
        return self
    }

    public func build() -> Product {
        return Product(intermediate)
    }
}

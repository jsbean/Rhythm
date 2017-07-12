//
//  Builder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

protocol DuratedContainerBuilder {
    associatedtype Product: DuratedContainer
    typealias Element = Product.Element
    var intermediate: SortedDictionary<Fraction,Element> { get set }
    @discardableResult func add(_: Element) -> Self
    @discardableResult func add <S: Sequence> (_: Element) -> Self where S.Iterator.Element == Element
    func build() -> Product
}

extension DuratedContainerBuilder {

//    public func build() -> Product {
//        return Product(result)
//    }
}

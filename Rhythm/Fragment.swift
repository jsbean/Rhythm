//
//  Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import ArithmeticTools

protocol Fragmentable {
    associatedtype Fragment
    subscript(range: Range<Fraction>) -> Fragment { get }
}

protocol DuratedFragment: Fragmentable {
    associatedtype Base: Fragmentable
    //typealias Fragment = Self
    var base: Base { get }
    var range: Range<Fraction> { get }
}

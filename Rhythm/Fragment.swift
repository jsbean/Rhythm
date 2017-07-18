//
//  Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

public protocol Fragmentable {
    associatedtype Fragment
    subscript(range: Range<Fraction>) -> Fragment { get }
}

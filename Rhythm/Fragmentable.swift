//
//  Fragmentable.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Algebra
import Collections
import ArithmeticTools

public protocol Fragmentable {
    associatedtype Fragment
    associatedtype Metric: SignedNumber, Additive
    subscript(range: Range<Metric>) -> Fragment { get }
}

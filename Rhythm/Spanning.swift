//
//  Spanning.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

// FIXME: Move to dn-m/Collections
public protocol Spanning {
    associatedtype Metric: SignedNumber
    var length: Metric { get }
}

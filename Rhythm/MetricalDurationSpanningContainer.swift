//
//  MetricalDurationSpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Algebra
import Collections
import ArithmeticTools

/// - Precondition: n + n.length = m
public protocol MetricalDurationSpanningContainer: SpanningContainer, MetricalDurationSpanning {

    // MARK: - Associated Types

    /// `MetricalDurationSpanningFragment`
    associatedtype Spanner: MetricalDurationSpanningFragment

    // MARK: - Instance Properties

    /// `MetricalDurationSpanningFragment` base, stored by their offset.
    ///
    // FIXME: This declaration should not be neceesary.
    // FIXME: Use constrained associated types in Swift 4:
    // https://github.com/apple/swift-evolution/blob/master/proposals/0142-associated-types-constraints.md
    var base: SortedDictionary<Fraction,Spanner> { get }
}

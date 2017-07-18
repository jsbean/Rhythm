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

    /// Constraint of Spanner type.
    associatedtype Spanner: SpanningFragment, MetricalDurationSpanning
}

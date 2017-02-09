//
//  MetricalDurationInterval.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import IntervalTools

/// `Interval` between two `MetricalDuration` values.
public typealias MetricalDurationInterval = Interval<MetricalDuration>

precedencegroup MetricalDurationIntervalInitializationPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator => : MetricalDurationIntervalInitializationPrecedence

/// Create a `MetricalDurationInterval` with the `=>` operator between two `MetricalDuration`
/// values.
public func => (start: MetricalDuration, stop: MetricalDuration) -> MetricalDurationInterval {
    return MetricalDurationInterval(start, stop)
}

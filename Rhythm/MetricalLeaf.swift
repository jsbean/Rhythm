//
//  MetricalLeaf.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// The leaf type of a `RhythmTree`, parameratized over `T`.
/// The `MetricalLeaf` wraps a `MetricalContext<T>` and a `MetricalDuration`.
///
/// - TODO: Change back to `MetricalLeaf`.
public typealias MetricalLeaf <T> = MetricalValue<MetricalContext<T>>

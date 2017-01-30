//
//  Leaf.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// The leaf type of a `RhythmTree`, parameratized over `T`.
/// The `MetricalNode` wraps a `MetricalContext<T>` and a `MetricalDuration`.
public typealias MetricalNode <T> = MetricalValue<MetricalContext<T>>

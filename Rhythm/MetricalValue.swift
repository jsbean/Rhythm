//
//  MetricalValue.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// Wraps a `MetricalDuration` with some `context` of type `T`.
///
/// Rename `context` to `payload`.
public struct MetricalValue <T> {
    
    // MARK: - Instance Properties
    
    /// Generic context of `MetricalValue`.
    public let payload: T
    
    /// Metrical duration of `MetricalValue`.
    public let metricalDuration: MetricalDuration
    
    // MARK: - Initializers
    
    /// Create a `MetricalValue` with a given `context` and `metricalDuration`.
    public init(_ payload: T, metricalDuration: MetricalDuration) {
        self.payload = payload
        self.metricalDuration = metricalDuration
    }
}

//
//  MetricalValue.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// Wraps a `MetricalDuration` with some `payload` of type `T`.
///
/// Rename `context` to `payload`.
public struct MetricalValue <T> {
    
    // MARK: - Instance Properties
    
    /// Metrical duration of `MetricalValue`.
    public let metricalDuration: MetricalDuration
    
    /// Generic payload of `MetricalValue`.
    public let payload: T
    
    // MARK: - Initializers
    
    /// Create a `MetricalValue` with a given `context` and `metricalDuration`.
    public init(_ metricalDuration: MetricalDuration, _ payload: T) {
        self.metricalDuration = metricalDuration
        self.payload = payload
    }
}

extension MetricalValue: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        return "\(metricalDuration): \(payload)"
    }
}

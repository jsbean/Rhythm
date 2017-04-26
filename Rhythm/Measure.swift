//
//  Measure.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

/// Model of musical measure.
///
/// - TODO: Evaluate necessity of storing `number`.
public struct Measure {
    
    // MARK: - Instance Properties
    
    /// Number of `Measure`.
    let number: Int
    
    /// Meter of `Measure`.
    let meter: Meter
    
    // MARK: - Instance Properties
    
    /// Creates a `Measure` with a given `number` and `meter`.
    public init(number: Int, meter: Meter) {
        self.number = number
        self.meter = meter
    }
}

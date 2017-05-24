//
//  Measure.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

/// Model of musical measure.
public struct Measure {
    
    // MARK: - Instance Properties
    
    /// Meter of `Measure`.
    let meter: Meter
    
    // MARK: - Instance Properties
    
    /// Creates a `Measure` with a given and `meter`.
    public init(meter: Meter) {
        self.meter = meter
    }
}

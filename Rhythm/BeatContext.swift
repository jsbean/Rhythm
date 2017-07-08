//
//  BeatContext.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import ArithmeticTools

/// Information about a given beat within a `Meter`.
public struct BeatContext {
    
    // MARK: - Instance Properties
    
    /// - returns: Metrical offset from start of a `Meter.Structure`.
    public var metricalOffset: MetricalDuration {
        return meterContext.offset + offset
    }
    
    /// Meter containing `BeatContext`.
    public let meterContext: Meter.Context
    
    /// Metrical offset of beat within `Meter`.
    public let offset: MetricalDuration

    // MARK: - Initializers
    
    /// Creates a `BeatContext` with the given `meterContext` at the given local `offset` `position`.
    public init(meterContext: Meter.Context, offset: MetricalDuration) {
        self.meterContext = meterContext
        self.offset = offset
    }
}

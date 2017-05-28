//
//  BeatContext.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

/// Information about a given beat within a `Meter`.
public struct BeatContext {
    
    // MARK: - Instance Properties
    
    /// Meter containing `BeatContext`.
    public let meter: Meter
    
    /// Metrical offset of beat within `Meter`.
    public let offset: MetricalDuration

    /// Context of tempo within `Tempo.Interpolation`.
    public let tempoContext: Tempo.Context

    // MARK: - Initializers
    
    /// Creates a `BeatContext` with the given `subdivision` and `position`.
    public init(meter: Meter, offset: MetricalDuration, interpolation: Tempo.Interpolation) {
        self.meter = meter
        self.offset = offset
        self.tempoContext = Tempo.Context(interpolation: interpolation, metricalOffset: offset)
    }
}

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
        return meterContext.offset + beatOffset
    }

    /// Meter containing `BeatContext`.
    public let meterContext: Meter.Context

    /// Metrical offset of beat within `Meter`.
    public let beatOffset: MetricalDuration

    /// Context of tempo within `Tempo.Interpolation`.
    public let tempoContext: Tempo.Context

    // MARK: - Initializers

    /// Creates a `BeatContext` with the given `subdivision` and `position`.
    public init(
        meterContext: Meter.Context,
        beatOffset: MetricalDuration,
        interpolation: Interpolation
    )
    {
        self.meterContext = meterContext
        self.beatOffset = beatOffset
        self.tempoContext = Tempo.Context(
            interpolation: interpolation,
            metricalOffset: Fraction(meterContext.offset + beatOffset)
        )
    }
}

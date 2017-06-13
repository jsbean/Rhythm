//
//  Meter.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import ArithmeticTools

/// Model of a `Meter`.
public struct Meter: Rational {
    
    // MARK: - Instance Properties
    
    /// - returns: The `MetricalDuration` of the `Meter`.
    public var metricalDuration: MetricalDuration {
        return numerator /> denominator
    }
    
    /// - returns: Array of `MetricalDuration` offsets of each beat in a meter.
    public var beatOffsets: [MetricalDuration] {
        return (0..<numerator).map { beat in MetricalDuration(beat, denominator) }
    }
    
    /// Numerator.
    public let numerator: Beats
    
    /// Denominator.
    public let denominator: Subdivision
    
    // MARK: Initializers
    
    /// Creates a `Meter` with the given `numerator` and `denominator`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {
        
        // TODO: Include denominators with power-of-two factors (28, 44, etc.),
        guard denominator.isPowerOfTwo else {
            fatalError("Cannot create a Meter with a non-power-of-two denominator")
        }
        
        guard numerator > 0 else {
            fatalError("Cannot create a Meter with a numerator of 0")
        }
        
        self.numerator = numerator
        self.denominator = denominator
    }
    
    // MARK: - Instance Methods
    
    /// - returns: Offsets of each beat of a `Meter` at the given `Tempo`.
    ///
    /// - TODO: Change [Double] -> [Seconds]
    ///
    public func offsets(tempo: Tempo) -> [Double] {
        let durationForBeat = tempo.duration(forBeatAt: denominator)
        return (0..<numerator).map { Double($0) * durationForBeat }
    }
    
    /// - returns: Duration in seconds of measure at the given `tempo`.
    public func duration(at tempo: Tempo) -> Double {
        return Double(numerator) * tempo.duration(forBeatAt: denominator)
    }
}

extension Meter: ExpressibleByIntegerLiteral {
    
    // MARK: - ExpressibleByIntegerLiteral
    
    /// Creates a `Meter` with the given amount of `beats` at the quarter-note level.
    public init(integerLiteral beats: Int) {
        self.init(beats, 4)
    }
}

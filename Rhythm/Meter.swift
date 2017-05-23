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
    
    /// Numerator.
    public let numerator: Int
    
    /// Denominator.
    public let denominator: Int
    
    // MARK: Initializers
    
    /// Creates a `Meter` with the given `numerator` and `denominator`.
    public init(_ numerator: Int, _ denominator: Int) {
        
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

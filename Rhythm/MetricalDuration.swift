//
//  MetricalDuration.swift
//  Rhythm
//
//  Created by James Bean on 1/2/17.
//
//

import ArithmeticTools

/// `MetricalDuration`.
public struct MetricalDuration: Rational {

    // MARK: - Type Properties
    
    public static let zero = MetricalDuration(0,1)
    
    // MARK: - Instance Properties
    
    /// Numerator.
    public let numerator: Beats

    /// Denominator.
    public let denominator: Subdivision
    
    // MARK: - Initializers
    
    /// Create a `MetricalDuration` with a `numerator` and `denominator`.
    public init(_ numerator: Beats, _ denominator: Subdivision) {
        
        guard denominator.isPowerOfTwo else {
            fatalError(
                "Cannot create MetricalDuration with non-power-of-two denominator: " +
                "\(denominator)"
            )
        }
        
        self.numerator = numerator
        self.denominator = denominator
    }
}

infix operator /> : BitwiseShiftPrecedence

/// Create a `MetricalDuration` with the `/>` operator between two `Int` values.
public func /> (numerator: Beats, denominator: Subdivision) -> MetricalDuration {
    return MetricalDuration(numerator, denominator)
}

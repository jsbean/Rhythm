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
    public let numerator: Int

    /// Denominator.
    public let denominator: Int
    
    // MARK: - Initializers
    
    /// Create a `MetricalDuration` with a `numerator` and `denominator`.
    public init(_ numerator: Int, _ denominator: Int) {
        
        guard denominator.isPowerOfTwo else {
            fatalError("Cannot create MetricalDuration with non-power-of-two denominator")
        }
        
        self.numerator = numerator
        self.denominator = denominator
    }
}

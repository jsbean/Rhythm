//
//  MetricalDuration.swift
//  Rhythm
//
//  Created by James Bean on 1/2/17.
//
//

import ArithmeticTools

public struct MetricalDuration: Rational {

    /// Numerator.
    public var numerator: Int

    /// Denominator.
    public var denominator: Int
    
    public init(_ numerator: Int, _ denominator: Int) {
        
        guard denominator.isPowerOfTwo else {
            fatalError("Cannot create MetricalDuration with non-power-of-two denominator")
        }
        
        self.numerator = numerator
        self.denominator = denominator
    }
}

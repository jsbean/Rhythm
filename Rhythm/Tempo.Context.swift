//
//  Tempo.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/27/17.
//
//

import ArithmeticTools

extension Tempo {
    
    /// The context of a particular point within a `Tempo.Interpolation`.
    public struct Context {
        
        // MARK: - Instance Properties
        
        /// Effective tempo at current offset within interpolation.
        let tempo: Tempo
        
        /// Interpolation containing context.
        let interpolation: Interpolation
        
        // MARK: - Initializers
        
        /// Creates a `Tempo.Context` with a given `interpolation` and `metricalOffset`.
        public init <R: Rational> (interpolation: Interpolation, metricalOffset: R) {
            self.interpolation = interpolation
            self.tempo = interpolation.tempo(at: metricalOffset)
        }
    }
}

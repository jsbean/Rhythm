//
//  Tempo.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/27/17.
//
//

extension Tempo {
    
    /// The context of a particular point within a `Tempo.Interpolation`.
    public struct Context {
        
        // MARK: - Instance Properties
        
        /// Effective tempo at current offset within interpolation.
        public let tempo: Tempo
        
        /// Interpolation containing context.
        public let interpolation: Interpolation
        
        // MARK: - Initializers
        
        /// Creates a `Tempo.Context` with a given `interpolation` and `metricalOffset`.
        public init(interpolation: Interpolation, metricalOffset: MetricalDuration) {
            self.interpolation = interpolation
            self.tempo = interpolation.tempo(at: metricalOffset)
        }
    }
}

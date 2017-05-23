//
//  Tempo.Interpolation.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

extension Tempo {
    
    /// Interpolation between two `Tempo` values.
    ///
    /// - TODO: Consider defining multiple interpolation types (linear, exponential, etc.)
    ///
    public struct Interpolation {
        public let start: Tempo
        public let end: Tempo
    }
}

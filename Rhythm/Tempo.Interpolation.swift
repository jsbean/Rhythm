//
//  Tempo.Interpolation.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Foundation
import ArithmeticTools

extension Tempo {
    
    /// Interpolation between two `Tempo` values.
    ///
    /// - TODO: Consider defining multiple interpolation types (linear, exponential, etc.)
    ///
    public struct Interpolation {
        
        // MARK: Instance Properties
        
        /// Concrete duration of `Interpolation`, in seconds.
        public var duration: Double/*Seconds*/ {
            return secondsOffset(metricalOffset: metricalDuration)
        }
        
        /// Start tempo.
        public let start: Tempo
        
        /// End tempo.
        public let end: Tempo
        
        /// Metrical duration.
        public let metricalDuration: MetricalDuration
        
        // MARK: - Initializers
        
        /// Creates an `Interpolation` with the given `start` and `end` `Tempo` values, lasting
        /// for the given `MetricalDuration`.
        public init(start: Tempo, end: Tempo, duration: MetricalDuration) {
            self.start = start
            self.end = end
            self.metricalDuration = duration
        }
        
        // MARK: - Instance Properties
        
        /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration` 
        /// `offset`.
        ///
        /// - TODO: Change Double -> Seconds
        ///
        public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {
            
            let (start, end, duration, offset) = normalizedValues(offset: metricalOffset)
            
            // Concrete in seconds always zero if symbolic offset is zero.
            guard offset != .zero else {
                return 0
            }
            
            let beats = offset.numerator
            
            // Non-changing tempo can be calculated linearly, avoid division by 0
            guard start != end else {
                return Double(beats) / start.durationOfBeat
            }
            
            let tempoRange = end.beatsPerMinute - start.beatsPerMinute
            let beatPosition = (tempoRange / Double(duration.numerator)) * Double(beats)
            let beatTempo = start.beatsPerMinute + beatPosition
            let tempoOffset = (beatTempo - start.beatsPerMinute)
            let tempoProportion = beatTempo / start.beatsPerMinute
            
            // Offset in minutes
            let beatTime = (Double(beats) / tempoOffset) * log(tempoProportion)
            
            // Offset in seconds
            return beatTime * 60
        }
        
        private func normalizedValues(offset: MetricalDuration)
            -> (start: Tempo, end: Tempo, duration: MetricalDuration, offset: MetricalDuration)
        {
            
            let lcm = [
                start.subdivision,
                end.subdivision,
                metricalDuration.denominator,
                offset.denominator
            ].lcm
            
            return (
                start: start.respelling(subdivision: lcm),
                end: end.respelling(subdivision: lcm),
                duration: metricalDuration.respelling(denominator: lcm)!,
                offset: offset.respelling(denominator: lcm)!
            )
        }
    }
}

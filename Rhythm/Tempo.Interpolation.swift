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
        
        // MARK: - Associated Types
        
        /// Kind of `Interpolation`.
        public enum Kind {
            
            /// Linear interpolation.
            case linear
            
            /// Exponential interpolation with the given `exponent`.
            case exponential(exponent: Double)
            
            /// Logarithmic interpolation with the given `base`.
            case logarithmic(base: Double)
            
            /// Ease in / ease out
            case sine
            
            // Custom timing function modeled with cubic Bézier curve control points in the
            // form (x,y)
            case custom(controlPoint1: (Double, Double), controlPoint2: (Double, Double))
        }
        
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

        /// Kind of `Interpolation`.
        public let kind: Kind
        
        // MARK: - Initializers
        
        /// Creates an `Interpolation` with the given `start` and `end` `Tempo` values, lasting
        /// for the given metrical `duration`.
        public init(
            start: Tempo = Tempo(60),
            end: Tempo = Tempo(60),
            duration: MetricalDuration = 1/>4,
            kind: Kind = .linear
        )
        {
            self.start = start
            self.end = end
            self.metricalDuration = duration
            self.kind = kind
        }
        
        /// Creates a static `Interpolation` with the given `tempo`, lasting for the given
        /// metrical `duration`.
        public init(tempo: Tempo, duration: MetricalDuration = 1/>4) {
            self.start = tempo
            self.end = tempo
            self.metricalDuration = duration
            self.kind = .linear
        }
        
        // MARK: - Instance Properties
        
        /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration` 
        /// `offset`.
        ///
        /// - TODO: Change Double -> Seconds
        ///
        public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {
            
            // Concrete in seconds always zero if symbolic offset is zero.
            guard metricalOffset != .zero else {
                return 0
            }
            
            let (start, end, duration, offset) = normalizedValues(offset: metricalOffset)
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
        
        /// - returns: The effective tempo at the given `metricalOffset`.
        ///
        /// - TODO: Must incorporate non-linear interpolations if/when they are implemented!
        ///
        public func tempo(at metricalOffset: MetricalDuration) -> Tempo {
            
            guard (self.start != self.end) || (metricalOffset != .zero) else {
                return self.start
            }
            
            let (start, end, _, _) = normalizedValues(offset: metricalOffset)
            let position = (Fraction(metricalOffset) / Fraction(metricalDuration)).doubleValue
            let range = end.beatsPerMinute - start.beatsPerMinute
            let relativePosition = position * range
            let bpm = relativePosition + start.beatsPerMinute
            return Tempo(bpm, subdivision: start.subdivision)
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

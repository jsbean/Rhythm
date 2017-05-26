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
    public struct Interpolation {
        
        public let start: Tempo
        public let end: Tempo
        public let metricalDuration: MetricalDuration
        
        public var duration: Double/*Seconds*/ {
            return seconds(offset: metricalDuration)
        }
        
        public init(start: Tempo, end: Tempo, duration: MetricalDuration) {
            self.start = start
            self.end = end
            self.metricalDuration = duration
        }
        
        // TODO: Change Double -> Seconds
        public func seconds(offset: MetricalDuration) -> Double/*Seconds*/ {
            
            let (start, end, duration, offset) = normalizedValues(offset: offset)
            
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

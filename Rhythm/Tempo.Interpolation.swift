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
        public let duration: MetricalDuration
        
        public init(start: Tempo, end: Tempo, duration: MetricalDuration) {
            self.start = start
            self.end = end
            self.duration = duration
        }
        
        // TODO: Change Beats -> MetricalDuration
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
            
            // Offset in minutes
            let beatTime = (Double(beats) / (beatTempo - start.beatsPerMinute)) * log(beatTempo / start.beatsPerMinute)
            
            // Offset in seconds
            return beatTime * 60
        }
        
        private func normalizedValues(offset: MetricalDuration)
            -> (start: Tempo, end: Tempo, duration: MetricalDuration, offset: MetricalDuration)
        {
            let lcm: Int = [
                start.subdivision,
                end.subdivision,
                duration.denominator,
                offset.denominator
            ].lcm
            
            return (
                start: self.start.respelling(subdivision: lcm),
                end: self.end.respelling(subdivision: lcm),
                duration: self.duration.respelling(denominator: lcm)!,
                offset: offset.respelling(denominator: lcm)!
            )
        }
    }
}

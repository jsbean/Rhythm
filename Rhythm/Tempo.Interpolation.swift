//
//  Tempo.Interpolation.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Foundation

extension Tempo {
    
    /// Interpolation between two `Tempo` values.
    ///
    /// - TODO: Consider defining multiple interpolation types (linear, exponential, etc.)
    public struct Interpolation {
        
        public let start: Tempo
        public let end: Tempo
        public let duration: MetricalDuration
        
        // TODO: Change Beats -> MetricalDuration
        public func seconds(offset: Beats) -> Double/*Seconds*/ {
            
            // Concrete in seconds always zero if symbolic offset is zero.
            if offset == 0 {
                return 0
            }
            
            // Non-changing tempo, avoid division by 0
            if start == end {
                return Double(offset) / start.durationOfBeat
            }
            
            let tempoRange = end.beatsPerMinute - start.beatsPerMinute
            let beatPosition = (tempoRange / Double(duration.numerator)) * Double(offset)
            let beatTempo = start.beatsPerMinute + beatPosition
            
            // Offset in minutes
            let beatTime = (Double(offset) / (beatTempo - start.beatsPerMinute)) * log(beatTempo / start.beatsPerMinute)
            
            // Offset in seconds
            return beatTime * 60

        }
    }
}

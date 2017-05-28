//
//  Meter.Structure.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Collections
import ArithmeticTools

extension Meter {
    
    /// Model of a metrical structure. Combines meters with tempo interpolation information.
    public struct Structure {
        
        // MARK: - Instance Properties
        
        /// - returns: `BeatContext` values for each beat of each meter, along with their
        /// offset in Seconds.
        public var beatContextsWithOffsets: [(Double, BeatContext)] {
            
            let meterOffsets = meters.map { $0.metricalDuration }.accumulatingRight
            
            return zip(meterOffsets, meters).flatMap { meterOffset, meter in
                
                meter.beatOffsets.map { beatOffset in
                    
                    let metricalOffset = meterOffset + beatOffset
                    let interp = interpolation(containing: metricalOffset)
                    
                    let beatContext = BeatContext(
                        meter: meter,
                        offset: beatOffset,
                        interpolation: interp
                    )
                    
                    return (secondsOffset(metricalOffset), beatContext)
                }
            }
        }
        
        /// `Meter` values contained herein.
        public let meters: [Meter]
        
        /// `Tempo.Stratum` value contained herein.
        public let tempi: Tempo.Stratum
        
        // MARK: - Initializers
        
        /// Creates a `Meter.Structure` with the given `meters` and `tempi`.
        public init(meters: [Meter] = [], tempi: Tempo.Stratum = Tempo.Stratum()) {
            self.meters = meters
            self.tempi = tempi
        }
        
        // MARK: - Instance Methods
        
        /// - returns: Seconds offset for the given `metricalOffset`.
        public func secondsOffset(_ metricalOffset: MetricalDuration) -> Double/*Seconds*/ {
            return tempi.secondsOffset(for: metricalOffset)
        }
        
        /// - returns: `Tempo.Interpolation` value containing the given `metricalOffset`.
        public func interpolation(containing metricalOffset: MetricalDuration)
            -> Tempo.Interpolation
        {
            return tempi.interpolation(containing: metricalOffset)
        }
        
        /// - returns: Tempo context at the given `metricalOffset`.
        public func tempoContext(at metricalOffset: MetricalDuration) -> Tempo.Context {
            return tempi.tempoContext(at: metricalOffset)
        }
    }
}

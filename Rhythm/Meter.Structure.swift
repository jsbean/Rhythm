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
        
        /// - returns: Array of `MetricalDuration` values of offset of each meter contained 
        /// herein.
        public var meterOffsets: [MetricalDuration] {
            return meters.map { $0.metricalDuration }.accumulatingRight
        }
        
        /// - returns: Array of `MetricalDuration` values of offset of each beat contained
        /// herein.
        public var beatOffsets: [MetricalDuration] {
            let meterOffsetsAndBeatOffsets = zip(meterOffsets, meters.map { $0.beatOffsets })
            return meterOffsetsAndBeatOffsets.flatMap { meterOffset, beatOffsets in
                beatOffsets.map { beatOffset in meterOffset + beatOffset }
            }
        }
        
        /// - returns: Array of `Seconds` values of offset of each beat contained herein.
        public var offsets: [Double] {
            return beatOffsets.map(tempi.secondsOffset)
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
        public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {
            return tempi.secondsOffset(for: metricalOffset)
        }
        
        /// - returns: Tempo context at the given `metricalOffset`.
        public func tempoContext(at metricalOffset: MetricalDuration) -> Tempo.Context {
            return tempi.tempoContext(at: metricalOffset)
        }
    }
}

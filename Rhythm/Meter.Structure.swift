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
        
        /// - returns: `BeatContext` values for each beat of each meter.
        public var beatContexts: [BeatContext] {
            
            let meterOffsets = meters.map { $0.metricalDuration }.accumulatingRight
            
            return zip(meters, meterOffsets).map(Meter.Context.init).flatMap { meterContext in
                
                return meterContext.meter.beatOffsets.map { beatOffset in
                    
                    let metericalOffset = meterContext.offset + beatOffset
                    
                    return BeatContext(
                        meterContext: meterContext,
                        beatOffset: beatOffset,
                        interpolation: interpolation(containing: metericalOffset)
                    )
                }
            }
        }
        
        /// - TODO: Update `Double` -> `Seconds`
        public var beatOffsets: [Double] {
            return beatContexts.map { $0.metricalOffset }.map(concreteOffset)
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
        public func concreteOffset <R: Rational> (_ metricalOffset: R) -> Double/*Seconds*/ {
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

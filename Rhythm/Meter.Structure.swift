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
        
        /// - returns: Array of `MetricalDuration` values
        public var meterOffsets: [MetricalDuration] {
            var result: [MetricalDuration] = []
            var accum: MetricalDuration = .zero
            for meter in meters {
                result.append(accum)
                accum += meter.metricalDuration
            }
            return result
        }
        
        public let meters: [Meter]
        public let tempi: Tempo.Stratum
        
        public init(meters: [Meter] = [], tempi: Tempo.Stratum = Tempo.Stratum()) {
            self.meters = meters
            self.tempi = tempi
        }
    }
}

//
//  Tempo.Stratum.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Collections
import ArithmeticTools

extension Tempo {
    
    /// Collection of `Interpolation` values at `MetricalDuration` offsets.
    public struct Stratum {
        
        // TODO: Only compute this if `tempi` has been changed.
        public var offsets: [Double] {
            return tempi.reduce([0]) { accum, interpolationContext in
                let (_, interpolation) = interpolationContext
                return accum + interpolation.duration
            }
        }
        
        internal var tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]
        
        /// Creates a `Tempo.Stratum` with the given `tempi`.
        public init(tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]) {
            self.tempi = tempi
        }
        
        /// - returns: The offset in seconds of the given `metricalOffset`.
        public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {

            // Metrical offset of and interpolation containing metrical offset
            let index = indexOfInterpolation(containing: metricalOffset)
            let (metricalOffsetOfInterpolation, interpolation) = tempi[index]
            
            // Metrical offset within interpolation
            let metricalOffsetInInterpolation = metricalOffset - metricalOffsetOfInterpolation
            
            // Seconds offset of the interpolation containing the metrical offset
            let secondsOffsetOfInterpolation = offsets[index]

            // Seconds offset within interpolation
            let secondsOffsetInInterpolation = interpolation.secondsOffset(
                metricalOffset: metricalOffsetInInterpolation
            )
            
            // Return offset of interpolation adding offset within interpolation
            return secondsOffsetOfInterpolation + secondsOffsetInInterpolation
        }
        
        private func indexOfInterpolation(containing metricalOffset: MetricalDuration) -> Int {
            
            let intervals = tempi.map { offset, interp in
                offset..<(offset + interp.metricalDuration)
            }
            
            return intervals.index { $0.contains(metricalOffset) } ?? 0
        }
    }
}

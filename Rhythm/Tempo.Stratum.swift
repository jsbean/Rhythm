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
    
    /// Collection of `Tempo.Item` values.
    public struct Stratum {
        
        public var offsets: [Double] {
            var result: [Double] = []
            var offset: Double = 0
            for (_, interpolation) in tempi {
                result.append(offset)
                offset += interpolation.duration
            }
            return result
        }
        
        internal var tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]
        
        public init(tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]) {
            self.tempi = tempi
        }
        
        public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {

            // Metrical offset of and interpolation containing metrical offset
            let i = index(ofInterpolationContaining: metricalOffset)
            let (metricalOffsetOfInterpolation, interpolation) = tempi[i]
            
            // Metrical offset within interpolation
            let metricalOffsetInInterpolation = metricalOffset - metricalOffsetOfInterpolation
            
            // Seconds offset of the interpolation containing the metrical offset
            let secondsOffsetOfInterpolation = secondsOffset(
                forInterpolationAt: metricalOffsetOfInterpolation
            )

            // Seconds offset within interpolation
            let secondsOffsetInInterpolation = interpolation.secondsOffset(
                metricalOffset: metricalOffsetInInterpolation
            )
            
            return secondsOffsetOfInterpolation + secondsOffsetInInterpolation
        }
        
        private func index(ofInterpolationContaining metricalOffset: MetricalDuration) -> Int {
            return tempi
                .map { offset, interp in offset...(offset + interp.metricalDuration) }
                .index { $0.contains(metricalOffset) }
            ?? 0
        }
        
        private func secondsOffset(forInterpolationAt metricalOffset: MetricalDuration)
            -> Double
        {
            
            var accum: Double = 0
            for (offset, interpolation) in tempi {
                if offset == metricalOffset { return accum }
                accum += interpolation.duration
            }
            
            fatalError()
        }
    }
}

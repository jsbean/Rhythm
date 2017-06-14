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
        private var offsets: [Double] {
            return tempi.reduce([0]) { accum, interpolationContext in
                let (_, interpolation) = interpolationContext
                return accum + interpolation.duration
            }
        }
        
        // TODO: Add `didSet` to compute offsets
        internal var tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]
        
        // MARK: - Initializers
        
        /// Creates a `Tempo.Stratum` with the given `tempi`.
        public init(tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]) {
            self.tempi = tempi
        }
        
        /// - returns: The offset in seconds of the given `metricalOffset`.
        ///
        /// - TODO: Update `Double` to `Seconds`
        ///
        internal func secondsOffset <R: Rational> (for metricalOffset: R) -> Double {

            // Metrical offset of and interpolation containing metrical offset
            let index = indexOfInterpolation(containing: metricalOffset)
            let (metricalOffsetOfInterpolation, interpolation) = tempi[index]
            
            // Metrical offset within interpolation
            let metricalOffsetInInterpolation = (
                Fraction(metricalOffset) - Fraction(metricalOffsetOfInterpolation)
            )
            
            // Seconds offset of the interpolation containing the metrical offset
            let secondsOffsetOfInterpolation = offsets[index]

            // Seconds offset within interpolation
            let secondsOffsetInInterpolation = interpolation.secondsOffset(
                metricalOffset: metricalOffsetInInterpolation
            )
            
            // Return offset of interpolation adding offset within interpolation
            return secondsOffsetOfInterpolation + secondsOffsetInInterpolation
        }
        
        /// - returns: The tempo context at the given `metricalOffset`.
        internal func tempoContext <R: Rational> (at metricalOffset: R) -> Tempo.Context {
            let (offset, interp) = tempi[indexOfInterpolation(containing: metricalOffset)]
            let internalOffset = Fraction(metricalOffset) - Fraction(offset)
            return Tempo.Context(interpolation: interp, metricalOffset: internalOffset)
        }
        
        /// - returns: `Interpolation` containing the given `metricalOffset`.
        internal func interpolation <R: Rational> (containing metricalOffset: R)
            -> Interpolation
        {
            return tempi[indexOfInterpolation(containing: metricalOffset)].1
        }
        
        private func indexOfInterpolation <R: Rational> (containing metricalOffset: R) -> Int {
            
            let intervals = tempi
                .map { offset, interp in offset..<(offset + interp.metricalDuration) }
                .map { range in Fraction(range.lowerBound)...Fraction(range.upperBound) }
            
            return intervals.index { $0.contains(Fraction(metricalOffset)) } ?? 0
        }
    }
}

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

        /// Duration in Seconds of a `Tempo.Stratum`.
        public var duration: Double/*Seconds*/ {
            return tempi.map { _, interpolation in interpolation.duration }.sum
        }
        
        // TODO: Add `didSet` to compute offsets
        public var tempi: SortedDictionary<MetricalDuration, Interpolation>
        
        // MARK: - Initializers
        
        /// Creates a `Tempo.Stratum` with the given `tempi`.
        public init(tempi: SortedDictionary<MetricalDuration, Interpolation> = [:]) {
            //precondition(!tempi.isEmpty)
            self.tempi = tempi
        }

        public func fragment(from start: MetricalDuration, to end: MetricalDuration) -> Stratum {

            // TODO: Try to refactor to keep DRY
            let startInterpIndex = indexOfInterpolation(containing: start)
            let (startInterpOffset, startInterp) = tempi[startInterpIndex]
            let startOffsetInInterp = start - startInterpOffset

            let endInterpIndex = indexOfInterpolation(containing: end)
            let (endInterpOffset, endInterp) = tempi[endInterpIndex]
            let endOffsetInInterp = end - endInterpOffset

            let startSegment = startInterp.fragment(from: startOffsetInInterp)
            let endSegment = endInterp.fragment(to: endOffsetInInterp)

            var result = SortedDictionary<MetricalDuration,Interpolation>()

            // Add first segment
            result.insert(startSegment, key: .zero)

            // Add the innards
            if endInterpIndex > startInterpIndex {
                tempi[startInterpIndex + 1 ..< endInterpIndex].forEach { offset, interp in
                    result.insert(interp, key: offset - start)
                }
            }

            // Add last segment if it isn't at the end of the interpolation
            if endOffsetInInterp < endInterp.metricalDuration {
                result.insert(endSegment, key: end - start)
            }

            return Stratum(tempi: result)
        }
        
        /// - returns: The offset in seconds of the given `metricalOffset`.
        ///
        /// - TODO: Update `Double` to `Seconds`
        ///
        internal func secondsOffset(for metricalOffset: MetricalDuration) -> Double {

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
        
        /// - returns: The tempo context at the given `metricalOffset`.
        internal func tempoContext(at metricalOffset: MetricalDuration) -> Tempo.Context {
            let (offset, interp) = tempi[indexOfInterpolation(containing: metricalOffset)]
            let internalOffset = metricalOffset - offset
            return Tempo.Context(interpolation: interp, metricalOffset: internalOffset)
        }
        
        /// - returns: `Interpolation` containing the given `metricalOffset`.
        internal func interpolation(containing metricalOffset: MetricalDuration)
            -> Interpolation
        {
            return tempi[indexOfInterpolation(containing: metricalOffset)].1
        }
        
        private func indexOfInterpolation(containing metricalOffset: MetricalDuration) -> Int {

            guard metricalOffset <= tempi[tempi.endIndex - 1].0 else {
                return tempi.endIndex - 1
            }

            let intervals = tempi.map { offset, interp in
                offset..<(offset + interp.metricalDuration)
            }
            
            return intervals.index { $0.contains(metricalOffset) } ?? 0
        }
    }
}

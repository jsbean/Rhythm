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
        
        public class Builder {
            
            var tempi: SortedDictionary<MetricalDuration, (Tempo, Bool)> = [:]
            
            public init() { }
            
            public func add(
                _ tempo: Tempo,
                at offset: MetricalDuration,
                interpolating: Bool = false
            )
            {
                tempi[offset] = (tempo, interpolating)
            }
            
            public func build() -> Stratum {
                
                guard !tempi.isEmpty else {
                    return Stratum()
                }
                
                guard tempi.count > 1 else {
                    let (_ ,(tempo, _)) = tempi[0]
                    return Stratum(tempi: [.zero: Interpolation(tempo: tempo)])
                }
                
                var stratum = Stratum(tempi: [:])
                
                var last: (offset: MetricalDuration, tempo: Tempo, interpolating: Bool)?
                for index in tempi.indices {
                    
                    let (offset, (tempo, interpolating)) = tempi[index]
                    
                    if let last = last {
                        
                        let duration = offset - last.offset
                        let endTempo = last.interpolating ? tempo : last.tempo
                        
                        let interpolation = Interpolation(
                            start: last.tempo,
                            end: endTempo,
                            duration: duration
                        )
                        
                        stratum.tempi[last.offset] = interpolation
                    }
                    
                    // last one: cleanup
                    if index == tempi.endIndex - 1 {   
                        stratum.tempi[offset] = Interpolation(tempo: tempo)
                    }
                    
                    last = (offset, tempo, interpolating)
                    
                    
                }
                
                return stratum
            }
        }
        
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
            
            let intervals = tempi.map { offset, interp in
                offset..<(offset + interp.metricalDuration)
            }
            
            return intervals.index { $0.contains(metricalOffset) } ?? 0
        }
    }
}

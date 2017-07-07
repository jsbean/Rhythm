//
//  Tempo.Stratum.Builder.swift
//  Rhythm
//
//  Created by James Bean on 5/31/17.
//
//

import Collections
import ArithmeticTools

extension Tempo.Stratum {
    
    /// Builder for a `Tempo.Stratum`.
    public class Builder {

        // The tempo information compiled through the build process.
        internal var tempi: SortedDictionary<MetricalDuration, (Tempo, Bool)> = [:]

        // MARK: - Initializers
        
        /// Creates a `Tempo.Stratum.Builder` prepared to build a `Tempo.Stratum`.
        public init() { }
        
        // MARK: - Instance Properties
        
        /// Add the given `tempo` at the given `offset`, and whether or not it shall be
        /// prepared to interpolate to the next given tempo.
        public func addTempo(
            _ tempo: Tempo,
            at offset: MetricalDuration,
            interpolating: Bool = false
        )
        {
            tempi[offset] = (tempo, interpolating)
        }
        
        /// - Returns: `Tempo.Stratum` value with the `tempo` values injected through the use
        /// of the `add(:at:interpolating)` method.
        public func build() -> Tempo.Stratum {
            
            // If no tempi have been added, return a `Tempo.Stratum` value with a single
            // value of `Tempo(60)` at an offset of `.zero`.
            guard !tempi.isEmpty else {
                return Tempo.Stratum()
            }
//            
//            // If only a single tempo has been added, create a `Tempo.Stratum` with a single
//            // value of the tempo added, at an offset of `.zero`.
//            guard tempi.count > 1 else {
//                let (_ ,(tempo, _)) = tempi[0]
//                return Tempo.Stratum(tempi: [.zero: Interpolation(tempo: tempo)])
//            }

            var stratum = Tempo.Stratum(tempi: [:])
            
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
//                
//                // last one: cleanup
//                if index == tempi.endIndex - 1 {
//                    stratum.tempi[offset] = Interpolation(tempo: tempo)
//                }

                last = (offset, tempo, interpolating)
            }
            
            return stratum
        }
    }
}

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
        ///
        /// - TODO: Only expose
        public func addTempo(
            _ tempo: Tempo,
            at offset: MetricalDuration,
            interpolating: Bool = false
        ) -> Builder
        {
            tempi[offset] = (tempo, interpolating)
        }

        /// Only call this just before `build()`
        public func fit(to meters: Meter.Collection) -> Builder {

            // Reproduces the first tempo / interpolation at zero offset, unless already at zero
            func snapFirstToBeginning() {

                let (offset, tempoAndInterpolating) = tempi[0]
                let (tempo, _) = tempoAndInterpolating

                if offset > .zero {
                    addTempo(tempo, at: .zero)
                }
            }

            // Reproduces the last tempo at the end
            //
            // FIXME: Truncate if necessary
            func snapLastToEnd() {

                let value = tempi[tempi.count - 1]
                let (offset, tempoAndInterpolating) = value
                let (tempo, _) = tempoAndInterpolating

                if offset < meters.length {
                    addTempo(tempo, at: meters.length)
                }
            }

            if tempi.isEmpty {
                addTempo(Tempo(60), at: .zero)
                addTempo(Tempo(60), at: meters.length)
                return
            }

            snapFirstToBeginning()
            snapLastToEnd()
        }
        
        /// - Returns: `Tempo.Stratum` value with the `tempo` values injected through the use
        /// of the `add(:at:interpolating)` method.
        public func build() -> Tempo.Stratum {
            
            // If no tempi have been added, return a `Tempo.Stratum` value with a single
            // value of `Tempo(60)` at an offset of `.zero`.
            guard !tempi.isEmpty else {
                return Tempo.Stratum()
            }

            // FIXME: Refactor to use `reduce`.
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

                last = (offset, tempo, interpolating)
            }
            
            return stratum
        }
    }
}

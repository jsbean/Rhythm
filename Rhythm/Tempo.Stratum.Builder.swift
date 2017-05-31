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
    
    public class Builder {

        private var tempi: SortedDictionary<MetricalDuration, (Tempo, Bool)> = [:]

        public init() { }
        
        public func add(
            _ tempo: Tempo,
            at offset: MetricalDuration,
            interpolating: Bool = false
        )
        {
            tempi[offset] = (tempo, interpolating)
        }
        
        public func build() -> Tempo.Stratum {
            
            guard !tempi.isEmpty else {
                return Tempo.Stratum()
            }
            
            guard tempi.count > 1 else {
                let (_ ,(tempo, _)) = tempi[0]
                return Tempo.Stratum(tempi: [.zero: Tempo.Interpolation(tempo: tempo)])
            }
            
            var stratum = Tempo.Stratum(tempi: [:])
            
            var last: (offset: MetricalDuration, tempo: Tempo, interpolating: Bool)?
            for index in tempi.indices {
                
                let (offset, (tempo, interpolating)) = tempi[index]
                
                if let last = last {
                    
                    let duration = offset - last.offset
                    let endTempo = last.interpolating ? tempo : last.tempo
                    
                    let interpolation = Tempo.Interpolation(
                        start: last.tempo,
                        end: endTempo,
                        duration: duration
                    )
                    
                    stratum.tempi[last.offset] = interpolation
                }
                
                // last one: cleanup
                if index == tempi.endIndex - 1 {
                    stratum.tempi[offset] = Tempo.Interpolation(tempo: tempo)
                }
                
                last = (offset, tempo, interpolating)
            }
            
            return stratum
        }
    }
}

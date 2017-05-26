//
//  Tempo.Stratum.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Collections

extension Tempo {
    
    /// Collection of `Tempo.Item` values.
    public struct Stratum {
        
        var tempi: [MetricalDuration: Interpolation] = [:]
        
        // tempo(offset: MetricalDuration)
        
        // seconds(offset: MetricalDuration) -> Seconds { }
        
    }
}

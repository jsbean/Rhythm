//
//  Meter.Structure.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

extension Meter {
    
    /// Model of a metrical structure. Combines meters with tempo interpolation information.
    struct Structure {
        public let meters: [Meter]
        public let tempi: Tempo.Stratum
    }
}

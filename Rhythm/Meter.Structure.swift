//
//  Meter.Structure.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

extension Meter {
    
    /// Model of a metrical structure. Combines meters with tempo interpolation information.
    public struct Structure {
        
        public let meters: [Meter]
        public let tempi: Tempo.Stratum
        
        public init(meters: [Meter] = [], tempi: Tempo.Stratum = Tempo.Stratum()) {
            self.meters = meters
            self.tempi = tempi
        }
    }
}

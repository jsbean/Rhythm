//
//  Meter.Structure.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/6/17.
//
//

extension Meter.Structure {

    public struct Fragment {

        public let meters: [Meter.Fragment]
        public let tempi: Tempo.Stratum

        public init(meters: [Meter.Fragment] = [], tempi: Tempo.Stratum = Tempo.Stratum()) {
            self.meters = meters
            self.tempi = tempi
        }
    }
}

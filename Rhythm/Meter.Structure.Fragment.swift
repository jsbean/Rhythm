//
//  Meter.Structure.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/6/17.
//
//

import ArithmeticTools

extension Meter.Structure {

    public struct Fragment {

        // FIXME: Refactor as `reduce`.
        public var beatOffsets: [Fraction] {
            var result: [Fraction] = []
            var accum: Fraction = .unit
            for meter in meters {
                let offsets = meter.beatOffsets.map { $0 + accum }
                result.append(contentsOf: offsets)
                accum += (meter.range.upperBound - meter.range.lowerBound)
            }
            return result
        }

        /// Duration in Seconds of a `Meter.Structure.Fragment`.
        public var duration: Double/*Seconds*/ {
            return tempi.duration
        }

        public let meters: [Meter.Fragment]
        public let tempi: Tempo.Stratum

        public init(meters: [Meter.Fragment] = [], tempi: Tempo.Stratum = Tempo.Stratum()) {
            self.meters = meters
            self.tempi = tempi
        }
    }
}

extension Meter.Structure.Fragment {

    /// Creates a `Meter.Structure.Fragment` identifcal to the given `meterStructure`.
    public init(_ meterStructure: Meter.Structure) {
        let meters = meterStructure.meters.map { Meter.Fragment($0) }
        self.init(meters: meters, tempi: meterStructure.tempi)
    }
}

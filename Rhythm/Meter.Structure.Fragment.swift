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

        public var beatContexts: [BeatContext] {

            let meterOffsets = meters
                .map { $0.range.upperBound - $0.range.lowerBound }
                .accumulatingRight

            var result: [BeatContext] = []
            for (offset, meter) in zip(meterOffsets, meters) {
                let contexts = meter.meterContexts
                for context in contexts {
                    for beatOffset in meter.beatOffsets {
                        let fractionOffset = offset + beatOffset
                        let metricalOffset = fractionOffset.numerator /> fractionOffset.denominator
                        let beatContext = BeatContext(
                            meterContext: context,
                            offset: beatOffset.numerator /> beatOffset.denominator
                        )
                        result.append(beatContext)
                    }
                }
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

        /// - returns: Seconds offset for the given `metricalOffset`.
        public func secondsOffset(_ metricalOffset: MetricalDuration) -> Double/*Seconds*/ {
            return tempi.secondsOffset(for: metricalOffset)
        }

        /// - returns: `Tempo.Interpolation` value containing the given `metricalOffset`.
        public func interpolation(containing metricalOffset: MetricalDuration)
            -> Interpolation
        {
            return tempi.interpolation(containing: metricalOffset)
        }

        /// - returns: Tempo context at the given `metricalOffset`.
        public func tempoContext(at metricalOffset: MetricalDuration) -> Tempo.Context {
            return tempi.tempoContext(at: metricalOffset)
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

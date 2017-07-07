//
//  Meter.Structure.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Collections
import ArithmeticTools

extension Meter {
    
    /// Model of a metrical structure. Combines meters with tempo interpolation information.
    public struct Structure {

        public final class Builder {

            private lazy var duration: MetricalDuration = {
                return self.meters.map { $0.numerator /> $0.denominator }.sum
            }()

            private var meters: [Meter] = []
            private var tempoStratumBuilder = Tempo.Stratum.Builder()

            public init() { }

            public func addMeter(_ meter: Meter) {
                meters.append(meter)
            }

            public func addTempo(
                _ tempo: Tempo,
                at offset: MetricalDuration,
                interpolating: Bool = false
            )
            {
                tempoStratumBuilder.addTempo(tempo, at: offset, interpolating: interpolating)
            }

            public func build() -> Meter.Structure {
                fitTempoStratumToMeters()
                let tempi = tempoStratumBuilder.build()
                return Meter.Structure(meters: meters, tempi: tempi)
            }

            // Fits the last tempo interpolation to
            private func fitTempoStratumToMeters() {

                // If no tempos have been added, just make it 60 bpm for the total length.
                if tempoStratumBuilder.tempi.isEmpty {
                    tempoStratumBuilder.addTempo(Tempo(60), at: .zero)
                    tempoStratumBuilder.addTempo(Tempo(60), at: duration)
                    return
                }

                snapFirstToBeginning()
                snapLastToEnd()
            }

            private func snapFirstToBeginning() {

                let (offset, tempoAndInterpolating) = tempoStratumBuilder.tempi[0]
                let (tempo, _) = tempoAndInterpolating

                if offset > .zero {
                    tempoStratumBuilder.addTempo(tempo, at: .zero)
                }
            }

            private func snapLastToEnd() {

                // Make DictionaryType bidirectional collection to get `.first` and `.last` !
                let value = tempoStratumBuilder.tempi[tempoStratumBuilder.tempi.count - 1]
                let (offset, tempoAndInterpolating) = value
                let (tempo, _) = tempoAndInterpolating

                if offset < duration {
                    tempoStratumBuilder.addTempo(tempo, at: duration)
                }
            }
        }

        // MARK: - Instance Properties
        
        /// - returns: `BeatContext` values for each beat of each meter.
        public var beatContexts: [BeatContext] {
            
            let meterOffsets = meters.map { $0.metricalDuration }.accumulatingRight
            
            return zip(meters, meterOffsets).map(Meter.Context.init).flatMap { meterContext in
                
                return meterContext.meter.beatOffsets.map { beatOffset in
                    
                    let metericalOffset = meterContext.offset + beatOffset
                    
                    return BeatContext(
                        meterContext: meterContext,
                        beatOffset: beatOffset,
                        interpolation: interpolation(containing: metericalOffset)
                    )
                }
            }
        }
        
        /// - TODO: Update `Double` -> `Seconds`
        public var beatOffsets: [Double] {
            return beatContexts.map { $0.metricalOffset }.map(secondsOffset)
        }

        /// Duration in Seconds of a `Meter.Structure`.
        public var duration: Double/*Seconds*/ {
            return tempi.duration
        }
        
        /// `Meter` values contained herein.
        public let meters: [Meter]
        
        /// `Tempo.Stratum` value contained herein.
        public let tempi: Tempo.Stratum
        
        // MARK: - Initializers
        
        /// Creates a `Meter.Structure` with the given `meters` and `tempi`.
        public init(meters: [Meter] = [], tempi: Tempo.Stratum = Tempo.Stratum()) {
            self.meters = meters
            self.tempi = tempi
        }
        
        // MARK: - Instance Methods

        public func fragment(from start: MetricalDuration, to end: MetricalDuration) -> Fragment {
            print("Meter.Structure.fragment from: \(start) to: \(end)")
            let meters = makeMeterFragments(from: start, to: end)
            let tempi = self.tempi.fragment(from: start, to: end)
            print("meters:")
            dump(meters)
            print("tempi:")
            dump(tempi)
            return Fragment(meters: meters, tempi: tempi)
        }

        private func makeMeterFragments(from start: MetricalDuration, to end: MetricalDuration)
            -> [Meter.Fragment]
        {

            // TODO: Try to refactor using `zip` and `reduce`
            var ranges: [Range<Fraction>] = {
                var result: [Range<Fraction>] = []
                var accum: Fraction = .unit
                for meter in meters {
                    let length = Fraction(meter)
                    result.append(accum ..< accum + length)
                    accum += length
                }
                return result
            }()

            var firstFragmentIndex: Int = {
                for (r,range) in ranges.enumerated() where range.contains(Fraction(start)) {
                    return r
                }
                return 0
            }()

            var lastFragmentIndex: Int = {
                for (r,range) in ranges.enumerated().reversed() where range.contains(Fraction(end)) {
                    return r
                }
                return ranges.endIndex - 1
            }()

            var innards: [Meter.Fragment] {
                if firstFragmentIndex == lastFragmentIndex { return [] }
                return Array(
                    (firstFragmentIndex + 1 ..< lastFragmentIndex).map { index in
                        let meter = meters[index]
                        let fragment = Meter.Fragment(meter)
                        return fragment
                    }
                )
            }

            let firstOffsetInRange = Fraction(start) - ranges[firstFragmentIndex].lowerBound
            let firstFragment = Meter.Fragment(meters[firstFragmentIndex], from: firstOffsetInRange)
            let lastOffsetInRange = Fraction(end) - ranges[lastFragmentIndex].lowerBound

            // If the length of the last fragment will be zero, don't add it
            guard lastOffsetInRange > .unit else {
                return firstFragment + innards
            }

            let lastFragment = Meter.Fragment(meters[lastFragmentIndex], to: lastOffsetInRange)
            return firstFragment + innards + lastFragment
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

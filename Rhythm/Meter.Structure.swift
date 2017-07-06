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
            let meters = makeMeterFragments(from: start, to: end)
            let tempi = self.tempi.fragment(from: start, to: end)
            return Fragment(meters: meters, tempi: tempi)
        }

        private func makeMeterFragments(from start: MetricalDuration, to end: MetricalDuration)
            -> [Meter.Fragment]
        {

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

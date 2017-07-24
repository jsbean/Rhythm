//
//  Tempo.Interpolation.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Darwin
import Collections
import ArithmeticTools

extension Tempo {

    /// Interpolation between two `Tempo` values.
    public struct Interpolation: MetricalDurationSpanning {

        // MARK: Instance Properties

        /// Concrete duration of `Interpolation`, in seconds.
        public var duration: Double/*Seconds*/ {
            return secondsOffset(for: length)
        }

        /// Start tempo.
        public let start: Tempo

        /// End tempo.
        public let end: Tempo

        /// Metrical duration.
        public let length: Fraction

        /// Easing of `Interpolation`.
        public let easing: Easing

        // MARK: - Initializers

        /// Creates an `Interpolation` with the given `start` and `end` `Tempo` values, lasting
        /// for the given metrical `duration`.
        public init(
            start: Tempo = Tempo(60),
            end: Tempo = Tempo(60),
            length: Fraction = Fraction(1,4),
            easing: Easing = .linear
        )
        {
            self.start = start
            self.end = end
            self.length = length
            self.easing = easing
        }

        /// Creates a static `Interpolation` with the given `tempo`, lasting for the given
        /// metrical `duration`.
        public init(tempo: Tempo, length: Fraction = Fraction(1,4)) {
            self.start = tempo
            self.end = tempo
            self.length = length
            self.easing = .linear
        }

        // MARK: - Instance Properties

        /// - returns: The effective tempo at the given `metricalOffset`.
        ///
        /// - TODO: Must incorporate non-linear interpolations if/when they are implemented!
        ///
        public func tempo (at metricalOffset: Fraction) -> Tempo {
            let (start, end, _, _) = normalizedValues(offset: metricalOffset)
            let x = (metricalOffset / length).doubleValue
            let ratio = end.beatsPerMinute / start.beatsPerMinute
            let xEased = easing.evaluate(at: x)
            let scaledBpm = start.beatsPerMinute * pow(ratio, xEased)
            return Tempo(scaledBpm, subdivision: start.subdivision)
        }

        /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration`
        /// `offset`. If the easing type is .linear, this method gives an exact answer;
        /// otherwise, it uses an approximation method with complexity linear in the
        /// magnitude of `metricalOffset`.
        ///
        /// - TODO: Change Double -> Seconds
        ///
        public func secondsOffset(for metricalOffset: Fraction) -> Double/*Seconds*/ {

            let resolution = 1024

            // First, guard against the easy cases
            // 1. Zero offset => zero output
            guard metricalOffset != .zero else {
                return 0
            }

            // 2. Start tempo == end tempo
            let (start, end, duration, offset) = normalizedValues(offset: metricalOffset)
            guard start != end else {
                return Double(offset.numerator) * start.durationOfBeat
            }

            switch easing {

            case .linear:
                // 3. If Easing is linear, there is a simple and exact integral we can use
                let a = start.durationOfBeat
                let b = end.durationOfBeat
                let x = (metricalOffset / length).doubleValue
                let integralValue = (pow(b/a, x)-1) * a / log(b/a)
                return integralValue * Double(duration.numerator)

            default:

                // Base case: rough approximation
                let segmentsCount = Int(floor((offset / Fraction(1, resolution)).doubleValue))

                let accum: Double = (0..<segmentsCount).reduce(.zero) { accum, cur in
                    let tempo = self.tempo(at: Fraction(cur, resolution))
                    let duration = tempo.duration(forBeatAt: resolution)
                    return accum + duration
                }

                // If approximate resolution fits nicely, we are done
                if lcm(resolution, offset.denominator) == resolution {
                    return accum
                }

                // Add on bit that doesn't fit right
                let remainingOffset = Fraction(segmentsCount, resolution)
                let remainingTempo = tempo(at: remainingOffset)
                let remainingMetricalDuration = offset - remainingOffset
                let beats = remainingMetricalDuration.numerator
                let subdivision = remainingMetricalDuration.denominator
                let remaining = remainingTempo.duration(forBeatAt: subdivision) * Double(beats)
                return accum + remaining
            }
        }
        
        private func normalizedValues(offset: Fraction)
            -> (start: Tempo, end: Tempo, duration: Fraction, offset: Fraction)
        {
            
            let lcm = [
                start.subdivision,
                end.subdivision,
                length.denominator,
                offset.denominator
            ].lcm
            
            return (
                start: start.respelling(subdivision: lcm),
                end: end.respelling(subdivision: lcm),
                duration: length.scaling(denominator: lcm),
                offset: offset.scaling(denominator: lcm)
            )
        }
    }
}

extension Tempo.Interpolation: Fragmentable {

    public subscript(range: Range<Fraction>) -> Fragment {
        assert(range.lowerBound >= .zero)
        assert(range.upperBound <= length)
        return Fragment(self, in: range)
    }
}


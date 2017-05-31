//
//  Tempo.Interpolation.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Foundation
import ArithmeticTools

/// Interpolation between two `Tempo` values.
///
/// - TODO: Consider defining multiple interpolation types (linear, exponential, etc.)
///
public struct Interpolation {

    // MARK: - Associated Types
    public enum EasingError: Error {
        case badValues(String, [Double])
    }

    /// Easing of `Interpolation`.
    public enum Easing {

        /// Linear interpolation.
        case linear

        /// Exponential interpolation in, with the given `exponent`.
        case exponentialIn(exponent: Double)

        /// Exponential interpolation in-out, with the given `exponent`.
        case exponentialInOut(exponent: Double)

        /// Ease in / ease out
        case sineInOut

        // Custom timing function modeled with cubic Bézier curve control points in the
        // form (x,y)
        case custom(controlPoint1: (Double, Double), controlPoint2: (Double, Double))

        /// - returns: The easing function evaluated at evalX.
        ///
        func evaluate(_ p1: (Double, Double), _ p2: (Double, Double), _ evalX: Double) throws -> Double {
            return try evaluate(p1.0, p1.1, p2.0, p2.1, evalX)
        }

        /// - returns: The easing function evaluated at evalX.
        ///
        func evaluate(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ evalX: Double) throws -> Double {
            switch(self) {

            case .linear:
                if x2 == x1 {
                    if y2 == y1 {
                        if evalX == x1 {
                            return y1
                        } else {
                            throw EasingError.badValues("Input points are identical, but calculation value is not", [x1, y1, x2, y2, evalX])
                        }
                    } else {
                        throw EasingError.badValues("Input points have same x-value, but different y-values", [x1, y1, x2, y2, evalX])
                    }
                } else {
                    return ( (y2 - y1) * (evalX - x1) / (x2 - x1) ) + y1
                }

            default:
                fatalError("Evaluate not yet implemented for this Easing type!")
            }
        }
    }

    // MARK: Instance Properties

    /// Concrete duration of `Interpolation`, in seconds.
    public var duration: Double/*Seconds*/ {
        return secondsOffset(metricalOffset: metricalDuration)
    }

    /// Start tempo.
    public let start: Tempo

    /// End tempo.
    public let end: Tempo

    /// Metrical duration.
    public let metricalDuration: MetricalDuration

    /// Easing of `Interpolation`.
    public let easing: Easing

    // MARK: - Initializers

    /// Creates an `Interpolation` with the given `start` and `end` `Tempo` values, lasting
    /// for the given metrical `duration`.
    public init(
        start: Tempo = Tempo(60),
        end: Tempo = Tempo(60),
        duration: MetricalDuration = 1/>4,
        easing: Easing = .linear
        )
    {
        self.start = start
        self.end = end
        self.metricalDuration = duration
        self.easing = easing
    }

    /// Creates a static `Interpolation` with the given `tempo`, lasting for the given
    /// metrical `duration`.
    public init(tempo: Tempo, duration: MetricalDuration = 1/>4) {
        self.start = tempo
        self.end = tempo
        self.metricalDuration = duration
        self.easing = .linear
    }

    // MARK: - Instance Properties

    /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration`
    /// `offset`.
    ///
    /// - TODO: Change Double -> Seconds
    ///
    public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {

        // Concrete in seconds always zero if symbolic offset is zero.
        guard metricalOffset != .zero else {
            return 0
        }

        let (start, end, duration, offset) = normalizedValues(offset: metricalOffset)
        let beats = offset.numerator

        // Non-changing tempo can be calculated linearly, avoid division by 0
        guard start != end else {
            return Double(beats) / start.durationOfBeat
        }

        switch easing {

        default:
            fatalError("Easing not yet supported!")
        }
    }

    /// - returns: The effective tempo at the given `metricalOffset`.
    ///
    /// - TODO: Must incorporate non-linear interpolations if/when they are implemented!
    ///
    public func tempo(at metricalOffset: MetricalDuration) -> Tempo {

        guard (self.start != self.end) || (metricalOffset != .zero) else {
            return self.start
        }

        let (start, end, _, _) = normalizedValues(offset: metricalOffset)
        let position = (Fraction(metricalOffset) / Fraction(metricalDuration)).doubleValue
        let range = end.beatsPerMinute - start.beatsPerMinute
        let relativePosition = position * range
        let bpm = relativePosition + start.beatsPerMinute
        return Tempo(bpm, subdivision: start.subdivision)
    }

    private func normalizedValues(offset: MetricalDuration)
        -> (start: Tempo, end: Tempo, duration: MetricalDuration, offset: MetricalDuration)
    {

        let lcm = [
            start.subdivision,
            end.subdivision,
            metricalDuration.denominator,
            offset.denominator
            ].lcm

        return (
            start: start.respelling(subdivision: lcm),
            end: end.respelling(subdivision: lcm),
            duration: metricalDuration.respelling(denominator: lcm)!,
            offset: offset.respelling(denominator: lcm)!
        )
    }
}

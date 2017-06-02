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
public struct Interpolation {

    /// Easing of `Interpolation`.
    public enum Easing {
        
        // MARK: - Associated Types
        
        public enum Error: Swift.Error {
            case valueNotInDomain(Double, String)
        }

        /// Linear interpolation.
        case linear

        /// Exponential interpolation in, with the given `exponent`.
        case exponentialIn(exponent: Double)

        /// Exponential interpolation in-out, with the given `exponent`.
        case exponentialInOut(exponent: Double)

        /// Ease in / ease out (half sine wave)
        case sineInOut

        // Custom timing function modeled with cubic Bézier curve control points in the
        // form (x,y)
        case custom(controlPoint1: (Double, Double), controlPoint2: (Double, Double))

        /// - returns: The easing function evaluated at `x`.
        func evaluate(at x: Double) throws -> Double {
            
            guard (0...1).contains(x) else {
                throw Error.valueNotInDomain(x, "Input must lie in [0, 1]")
            }

            switch self {

            case .linear:
                return x

            case .exponentialIn(let e):
                
                guard e > 0 else {
                    throw Error.valueNotInDomain(e, "Exponent must be positive")
                }

                // x^e
                return pow(x, e)

            case .exponentialInOut(let e):
                
                guard e >= 1 else {
                    throw Error.valueNotInDomain(e, "Exponent must be at least 1")
                }

                if x <= 0.5 {
                    // (2^(e-1)) * x^e
                    return pow(x, e) * pow(2, e - 1)
                } else {
                    // (1-x)^e * -(2^(e-1)) + 1
                    return pow(1 - x, e) * -pow(2, e - 1) + 1
                }

            case .sineInOut:
                // (1 - cos(π*x)) / 2
                return 0.5 * (1 - cos(x * Double.pi))

            default:
                fatalError("Evaluate(at:) not yet implemented for \(self)")
            }
        }

        /// - returns: The integral of the easing function from 0 to `x`.
        func integrate(at x: Double) throws -> Double {

            guard (0...1).contains(x) else {
                throw Error.valueNotInDomain(x, "Input must lie in [0, 1]")
            }

            switch self {

            case .linear:
                // x^2 / 2
                return pow(x, 2) / 2

            case .exponentialIn(let e):

                guard e > 0 else {
                    throw Error.valueNotInDomain(e, "Exponent must be positive")
                }

                // x^(e+1) / (e+1)
                return pow(x, e + 1) / (e + 1)

            case .exponentialInOut(let e):

                guard e >= 1 else {
                    throw Error.valueNotInDomain(e, "Exponent must be at least 1")
                }

                if x <= 0.5 {
                    // (2^(e-1) / (e+1)) * x^(e+1)
                    return pow(2, e-1) / (e+1) * pow(x, (e+1))
                } else {
                    // (2^(e-1) * (1-x)^(1+e)) / (1+e) + x
                    return pow(2, e-1) * pow(1-x, 1+e) / (1+e) + x
                }


            case .sineInOut:
                //  (x - (sin(π*x))/π) / 2
                return (x - sin(Double.pi * x) / Double.pi) / 2

            default:
                fatalError("Integrate(at:) not yet implemented for \(self)")
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

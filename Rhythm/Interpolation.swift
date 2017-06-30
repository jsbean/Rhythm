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
        
        /// `x^e` interpolation in, with the given `exponent`.
        case powerIn(exponent: Double)
        
        /// `x^e` interpolation in-out, with the given `exponent`.
        case powerInOut(exponent: Double)
        
        /// `b^x` interpolation in, with the given `base`.
        case exponentialIn(base: Double)
        
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
                
            case .powerIn(let e):
                
                guard e > 0 else {
                    throw Error.valueNotInDomain(e, "Exponent must be positive")
                }
                
                // x^e
                return pow(x, e)
                
            case .powerInOut(let e):
                
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
                
            case .exponentialIn(let b):
                
                guard b > 0 else {
                    throw Error.valueNotInDomain(b, "Base must be positive")
                }
                guard b != 1 else {
                    throw Error.valueNotInDomain(b, "Base must not be 1")
                }
                
                // ((b^x)-1) / (b-1)
                return (pow(b, x)-1) / (b-1)
                
            case .sineInOut:
                // (1 - cos(π*x)) / 2
                return 0.5 * (1 - cos(x * .pi))
                
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
                
            case .powerIn(let e):
                
                guard e > 0 else {
                    throw Error.valueNotInDomain(e, "Exponent must be positive")
                }
                
                // x^(e+1) / (e+1)
                return pow(x, e + 1) / (e + 1)
                
            case .powerInOut(let e):
                
                guard e >= 1 else {
                    throw Error.valueNotInDomain(e, "Exponent must be at least 1")
                }
                
                if x <= 0.5 {
                    // (2^(e-1) / (e+1)) * x^(e+1)
                    return pow(2, e-1) / (e+1) * pow(x, (e+1))
                } else {
                    // (2^(e-1) * (1-x)^(1+e)) / (1+e) + x
                    // But since this is a piecewise calculation, we have to subtract this
                    // evaluated at 0.5 and add the value at 0.5 of the function directly above.
                    // This actually just amounts to adding a -.5 term; everything else cancels out.
                    return pow(2, e-1) * pow(1-x, 1+e) / (1+e) + x - 0.5
                }
                
            case .exponentialIn(let b):
                
                guard b > 0 else {
                    throw Error.valueNotInDomain(b, "Base must be positive")
                }
                guard b != 1 else {
                    throw Error.valueNotInDomain(b, "Base must not be 1")
                }
                
                // ((b^x)/ln b) - x) / (b-1)
                return ((pow(b, x)/log(b)) - x) / (b-1)
                
            case .sineInOut:
                //  (x - (sin(π*x))/π) / 2
                return (x - sin(.pi * x) / .pi) / 2
                
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
    
    /// - returns: The effective tempo at the given `metricalOffset`.
    ///
    /// - TODO: Must incorporate non-linear interpolations if/when they are implemented!
    ///
    public func tempo(at metricalOffset: MetricalDuration) -> Tempo {
        
        let (start, end, _, _) = normalizedValues(offset: metricalOffset)
        let x = (Fraction(metricalOffset) / Fraction(metricalDuration)).doubleValue
        let ratio = end.beatsPerMinute / start.beatsPerMinute
        let xEased = try! easing.evaluate(at: x)
        let scaledBpm = start.beatsPerMinute * pow(ratio, xEased)
        return Tempo(scaledBpm, subdivision: start.subdivision)
    }
    
    private static let approxResolution = 1024
    
    /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration`
    /// `offset`. If the easing type is .linear, this method gives an exact answer;
    /// otherwise, it uses an approximation method with complexity linear in the
    /// magnitude of `metricalOffset`.
    ///
    /// - TODO: Change Double -> Seconds
    ///
    public func secondsOffset(metricalOffset: MetricalDuration) -> Double/*Seconds*/ {
        
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
            let x = (Fraction(metricalOffset) / Fraction(metricalDuration)).doubleValue
            let integralValue = (pow(b/a, x)-1) * a / log(b/a)
            return integralValue * Double(duration.numerator);
            
        default:
            // Base case: rough approximation
            let numFullSegments = Int(floor((offset / (1 /> Interpolation.approxResolution)).doubleValue))
            var accum = 0.0
            for i in 0..<numFullSegments {
                let segmentTempo = tempo(at: i /> Interpolation.approxResolution)
                accum += segmentTempo.duration(forBeatAt: Interpolation.approxResolution)
            }
            // If the resolution parameter doesn't fit cleanly into the offset len, calculate
            // the last segment separately
            if (lcm(Interpolation.approxResolution, offset.denominator) != Interpolation.approxResolution) {
                let lastSegmentTempo = tempo(at: numFullSegments /> Interpolation.approxResolution)
                let lastSegmentDuration = offset - (numFullSegments /> Interpolation.approxResolution)
                accum += lastSegmentTempo.duration(forBeatAt: lastSegmentDuration.denominator) * Double(lastSegmentDuration.numerator)
            }
            return accum;
        }
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

//extension Tempo {
//    
//    /// Interpolation between two `Tempo` values.
//    ///
//    /// - TODO: Consider defining multiple interpolation types (linear, exponential, etc.)
//    ///
//    public struct Interpolation {
//        
//        // MARK: - Associated Types
//        
//        /// Kind of `Interpolation`.
//        public enum Kind {
//            
//            /// Linear interpolation.
//            case linear
//            
//            /// Exponential interpolation with the given `exponent`.
//            case exponential(exponent: Double)
//            
//            /// Logarithmic interpolation with the given `base`.
//            case logarithmic(base: Double)
//            
//            /// Ease in / ease out
//            case sine
//            
//            // Custom timing function modeled with cubic Bézier curve control points in the
//            // form (x,y)
//            case custom(controlPoint1: (Double, Double), controlPoint2: (Double, Double))
//        }
//        
//        // MARK: Instance Properties
//        
//        /// Concrete duration of `Interpolation`, in seconds.
//        public var duration: Double/*Seconds*/ {
//            return secondsOffset(metricalOffset: metricalDuration)
//        }
//        
//        /// Start tempo.
//        public let start: Tempo
//        
//        /// End tempo.
//        public let end: Tempo
//        
//        /// Metrical duration.
//        public let metricalDuration: MetricalDuration
//        
//        /// Kind of `Interpolation`.
//        public let kind: Kind
//        
//        // MARK: - Initializers
//        
//        /// Creates an `Interpolation` with the given `start` and `end` `Tempo` values, lasting
//        /// for the given metrical `duration`.
//        public init(
//            start: Tempo = Tempo(60),
//            end: Tempo = Tempo(60),
//            duration: MetricalDuration = 1/>4,
//            kind: Kind = .linear
//        )
//        {
//            self.start = start
//            self.end = end
//            self.metricalDuration = duration
//            self.kind = kind
//        }
//        
//        /// Creates a static `Interpolation` with the given `tempo`, lasting for the given
//        /// metrical `duration`.
//        public init(tempo: Tempo, duration: MetricalDuration = 1/>4) {
//            self.start = tempo
//            self.end = tempo
//            self.metricalDuration = duration
//            self.kind = .linear
//        }
//        
//        // MARK: - Instance Properties
//        
//        /// - returns: The concrete offset in seconds of the given symbolic `MetricalDuration`
//        /// `offset`.
//        ///
//        /// - TODO: Change Double -> Seconds
//        ///
//        public func secondsOffset <R: Rational> (metricalOffset: R) -> Double/*Seconds*/ {
//            
//            // Concrete in seconds always zero if symbolic offset is zero.
//            guard metricalOffset != .unit else {
//                return 0
//            }
//            
//            let (start, end, duration, offset) = normalizedValues(offset: metricalOffset)
//            let beats = offset.numerator
//            
//            // Non-changing tempo can be calculated linearly, avoid division by 0
//            guard start != end else {
//                return Double(beats) * start.durationOfBeat
//            }
//            
//            switch kind {
//                
//            case .linear:
//                
//                let tempoRange = end.beatsPerMinute - start.beatsPerMinute
//                let beatPosition = (tempoRange / Double(duration.numerator)) * Double(beats)
//                let beatTempo = start.beatsPerMinute + beatPosition
//                let tempoOffset = beatTempo - start.beatsPerMinute
//                let tempoProportion = beatTempo / start.beatsPerMinute
//                
//                // Offset in minutes
//                let beatTime = (Double(beats) / tempoOffset) * log(tempoProportion)
//                
//                // Offset in seconds
//                return beatTime * 60
//                
//            case .exponential(let exponent):
//                fatalError("Exponential interpolations not yet supported!")
//                
//            case .logarithmic(let base):
//                fatalError("Logarithmic interpolations not yet supported!")
//                
//            case .sine:
//                fatalError("Sine interpolations not yet supported!")
//                
//            case .custom(let (x1, y1), let (x2, y2)):
//                fatalError("Custom interpolations not yet supported!")
//            }
//        }
//        
//        /// - returns: The effective tempo at the given `metricalOffset`.
//        ///
//        /// - TODO: Must incorporate non-linear interpolations if/when they are implemented!
//        ///
//        public func tempo <R: Rational> (at metricalOffset: R) -> Tempo {
//            
//            guard (self.start != self.end) || (metricalOffset != .unit) else {
//                return self.start
//            }
//            
//            let (start, end, _, _) = normalizedValues(offset: metricalOffset)
//            let position = (Fraction(metricalOffset) / Fraction(metricalDuration)).doubleValue
//            let range = end.beatsPerMinute - start.beatsPerMinute
//            let relativePosition = position * range
//            let bpm = relativePosition + start.beatsPerMinute
//            return Tempo(bpm, subdivision: start.subdivision)
//        }
//        
//        private func normalizedValues <R: Rational> (offset: R)
//            -> (start: Tempo, end: Tempo, duration: MetricalDuration, offset: R)
//        {
//            
//            let lcm = [
//                start.subdivision,
//                end.subdivision,
//                metricalDuration.denominator,
//                offset.denominator
//            ].lcm
//            
//            return (
//                start: start.respelling(subdivision: lcm),
//                end: end.respelling(subdivision: lcm),
//                duration: metricalDuration.respelling(denominator: lcm)!,
//                offset: offset.respelling(denominator: lcm)!
//            )
//        }
//    }
//}

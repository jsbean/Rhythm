//
//  Interpolation.Easing.swift
//  Rhythm
//
//  Created by James Bean on 7/11/17.
//
//

import Darwin

extension Tempo.Interpolation {

    /// Easing of `Interpolation`.
    public enum Easing {

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

        /// - returns: The easing function evaluated at `x`.
        func evaluate(at x: Double) -> Double {

            assert((0...1).contains(x), "\(#function): input must lie in [0, 1]")

            switch self {

            case .linear:
                return x

            case .powerIn(let e):
                assert(e > 0, "\(#function): powerIn exponent must be positive")
                return pow(x, e)

            case .powerInOut(let e):
                assert(e >= 1, "\(#function): powerInOut exponent must be >= 1")
                if x <= 0.5 {
                    return pow(x, e) * pow(2, e - 1)
                } else {
                    return pow(1 - x, e) * -pow(2, e - 1) + 1
                }

            case .exponentialIn(let b):
                assert(b > 0, "\(#function): exponentialIn base must be > 0")
                assert(b != 1, "\(#function): exponentialIn base must not be 1")
                return (pow(b, x)-1) / (b-1)

            case .sineInOut:
                return 0.5 * (1 - cos(x * .pi))
            }
        }

        /// - returns: The integral of the easing function from 0 to `x`.
        func integrate(at x: Double) -> Double {

            assert((0...1).contains(x), "\(#function): input must lie in [0, 1]")

            switch self {

            case .linear:
                return pow(x, 2) / 2

            case .powerIn(let e):
                assert(e > 0, "\(#function): exponent must be positive")
                return pow(x, e + 1) / (e + 1)

            case .powerInOut(let e):
                assert(e > 0, "\(#function): Exponent must be at least 1")
                if x <= 0.5 {
                    return pow(2, e-1) / (e+1) * pow(x, (e+1))
                } else {
                    return pow(2, e-1) * pow(1-x, 1+e) / (1+e) + x - 0.5
                }

            case .exponentialIn(let b):
                assert(b > 0, "\(#function): Base must be positive")
                assert(b != 1, "\(#function): Base must not be 1")
                return ((pow(b, x)/log(b)) - x) / (b-1)
                
            case .sineInOut:
                return (x - sin(.pi * x) / .pi) / 2
            }
        }
    }
}

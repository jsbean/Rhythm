////
////  Tempo.Stratum.swift
////  Rhythm
////
////  Created by James Bean on 5/23/17.
////
////
//
//import Collections
//import ArithmeticTools
//
//extension Tempo {
//

//
//        /// - returns: The tempo context at the given `metricalOffset`.
//        internal func tempoContext <R: Rational> (at metricalOffset: R) -> Tempo.Context {
//            let (offset, interp) = tempi[indexOfInterpolation(containing: metricalOffset)]
//            let internalOffset = Fraction(metricalOffset) - Fraction(offset)
//            return Tempo.Context(interpolation: interp, metricalOffset: internalOffset)
//        }
//
//        /// - returns: `Interpolation` containing the given `metricalOffset`.
//        internal func interpolation <R: Rational> (containing metricalOffset: R)
//            -> Interpolation
//        {
//            return tempi[indexOfInterpolation(containing: metricalOffset)].1
//        }
//
//}

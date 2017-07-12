//
//  Tempo.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/11/17.
//
//

import Collections
import ArithmeticTools

public extension Tempo {

    public struct Collection: DuratedContainer {

        public typealias Storage = SortedDictionary<Fraction, Interpolation.Fragment>

        public let elements: Storage

        public init(_ elements: Storage) {
            self.elements = elements
        }

        /// - FIXME: Use `Seconds` instead of `Double`
        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            assert(contains(metricalOffset))
            let index = indexOfElement(containing: metricalOffset)!
            let (globalOffset, interpolation) = elements[index]
            let internalOffset = metricalOffset - globalOffset
            let localSeconds = interpolation.secondsOffset(for: internalOffset)
            return secondsOffset(at: index) + localSeconds
        }

        public func secondsOffset(at index: Int) -> Double {
            assert(elements.indices.contains(index))
            return (0..<index)
                .lazy
                .map { self.elements[$0] }
                .map { _, interp in interp.duration }
                .sum
        }
    }
}

extension Tempo.Collection: Fragmentable {

    subscript (range: Range<Fraction>) -> Meter.Collection {

        fatalError()

//        let startInterpIndex = indexOfInterpolation(containing: start)
//        let (startInterpOffset, startInterp) = tempi[startInterpIndex]
//        let startOffsetInInterp = start - startInterpOffset
//
//        let endInterpIndex = indexOfInterpolation(containing: end)
//        let (endInterpOffset, endInterp) = tempi[endInterpIndex]
//        let endOffsetInInterp = end - endInterpOffset
//
//        let startSegment = startInterp.fragment(from: startOffsetInInterp, to: end - startInterpOffset)
//
//        var result = SortedDictionary<MetricalDuration,Interpolation>()
//
//        // Add first segment
//        result.insert(startSegment, key: .zero)
//
//        if startInterpIndex == endInterpIndex {
//            return Stratum(tempi: result)
//        }
//
//        let endSegment = endInterp.fragment(to: endOffsetInInterp)
//
//        // Add the innards
//        if endInterpIndex > startInterpIndex + 1 {
//            tempi[startInterpIndex + 1 ..< endInterpIndex].forEach { offset, interp in
//                result.insert(interp, key: offset - start)
//            }
//        }
//
//        // Add last segment if it isn't at the end of the interpolation
//        if endOffsetInInterp < endInterp.metricalDuration {
//            result.insert(endSegment, key: end - start)
//        }
//
//        return Stratum(tempi: result)
    }
}

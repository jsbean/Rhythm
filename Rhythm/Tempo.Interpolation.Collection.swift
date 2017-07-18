//
//  Tempo.Interpolation.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/11/17.
//
//

import Collections
import ArithmeticTools

public extension Tempo.Interpolation {

    public struct Collection: MetricalDurationSpanningContainer {

        public typealias Storage = SortedDictionary<Fraction, Tempo.Interpolation.Fragment>

        public let base: Storage

        public init(_ base: Storage) {
            self.base = base
        }

        public init <S> (_ base: S)
            where S: Sequence, S.Iterator.Element == Tempo.Interpolation.Fragment
        {
            self = Builder().add(base).build()
        }

        public init <S> (_ elements: [Tempo.Interpolation])
            where S: Sequence, S.Iterator.Element == Tempo.Interpolation
        {
            self.init(elements.map { Tempo.Interpolation.Fragment($0) })
        }

        /// - FIXME: Use `Seconds` instead of `Double`
        public func secondsOffset(for metricalOffset: Fraction) -> Double {
            assert(contains(metricalOffset))
            let index = indexOfElement(containing: metricalOffset)!
            let (globalOffset, interpolation) = base[index]
            let internalOffset = metricalOffset - globalOffset
            let localSeconds = interpolation.secondsOffset(for: internalOffset)
            return secondsOffset(at: index) + localSeconds
        }

        public func secondsOffset(at index: Int) -> Double {
            assert(base.indices.contains(index))
            return (0..<index)
                .lazy
                .map { self.base[$0] }
                .map { _, interp in interp.duration }
                .sum
        }
    }
}

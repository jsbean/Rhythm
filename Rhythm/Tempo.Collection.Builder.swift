//
//  Tempo.Collection.Builder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

extension Tempo.Collection {

    public final class Builder: DuratedContainerBuilder {

        typealias Product = Tempo.Collection

        internal var intermediate: SortedDictionary<Fraction,Interpolation.Fragment>
        private var last: (Fraction, Tempo, Bool)?
        private var offset: Fraction

        public init() {
            self.intermediate = [:]
            self.offset = .unit
        }

        @discardableResult func add(_ interpolation: Interpolation.Fragment) -> Builder {
            self.intermediate.insert(interpolation, key: offset)
            last = (offset, interpolation.base.end, true)
            offset += interpolation.range.length
            return self
        }

        @discardableResult func add(_ interpolations: [Interpolation.Fragment]) -> Builder {
            interpolations.forEach { _ = add($0) }
            return self
        }

        @discardableResult func add(
            _ tempo: Tempo,
            at offset: Fraction,
            interpolating: Bool = false
        ) -> Builder
        {
            if let (startOffset, startTempo, startInterpolating) = last {
                let interpolation = Interpolation(
                    start: startTempo,
                    end: startInterpolating ? tempo : startTempo,
                    duration: offset - startOffset,
                    easing: .linear
                )
                add(.init(interpolation))
            }
            last = (offset, tempo, interpolating)
            return self
        }
    }
}

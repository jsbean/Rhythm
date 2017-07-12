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

    public final class Builder: BuilderProtocol {

        private var intermediate: SortedDictionary<Fraction, (tempo: Tempo, interpolating: Bool)>

        public init() {
            self.intermediate = [:]
        }

        @discardableResult func add(
            _ tempo: Tempo,
            at offset: Fraction,
            interpolating: Bool = false
        ) -> Builder
        {
            intermediate[offset] = (tempo, interpolating)
            return self
        }

        func build() -> Tempo.Collection {
            return Tempo.Collection(
                SortedDictionary(
                    intermediate.adjacentPairs().map { pair in
                        let ((startOffset, start), (endOffset, end)) = pair
                        let interpolation = Interpolation(
                            start: start.tempo,
                            end: end.tempo,
                            duration: endOffset - startOffset,
                            easing: .linear
                        )
                        return (startOffset, .init(interpolation))
                    }
                )
            )
        }
    }
}

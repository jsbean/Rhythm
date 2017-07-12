//
//  Meter.Collection.Builder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

extension Meter.Collection {

    public final class Builder: BuilderProtocol {

        private var result: SortedDictionary<Fraction,Meter.Fragment>
        private var offset: Fraction

        public init() {
            self.result = [:]
            self.offset = .unit
        }

        @discardableResult public func addMeter(_ meter: Meter.Fragment) -> Builder {
            self.result.insert(meter, key: offset)
            offset += meter.range.length
            return self
        }

        @discardableResult public func addMeter(_ meter: Meter) -> Builder {
            let fragment = Meter.Fragment(meter)
            return addMeter(fragment)
        }

        @discardableResult public func addMeters(_ meters: [Meter.Fragment]) -> Builder {
            meters.forEach { _ = addMeter($0) }
            return self
        }

        func build() -> Meter.Collection {
            return Meter.Collection(result)
        }
    }
}

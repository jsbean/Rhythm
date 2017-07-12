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

    public final class Builder: DuratedContainerBuilder {

        typealias Product = Meter.Collection

        internal var intermediate: SortedDictionary<Fraction,Meter.Fragment>
        private var offset: Fraction

        public init() {
            self.intermediate = [:]
            self.offset = .unit
        }

        @discardableResult public func add(_ meter: Meter.Fragment) -> Builder {
            self.intermediate.insert(meter, key: offset)
            offset += meter.range.length
            return self
        }

        @discardableResult public func add(_ meters: [Meter.Fragment]) -> Builder {
            meters.forEach { _ = add($0) }
            return self
        }
    }
}

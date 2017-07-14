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

    public final class Builder: MetricalDurationSpanningContainerBuilder {

        public typealias Product = Meter.Collection

        public var intermediate: SortedDictionary<Fraction,Meter.Fragment>
        public var offset: Fraction

        public init() {
            self.intermediate = [:]
            self.offset = .unit
        }
    }
}

//
//  Meter.Context.swift
//  Rhythm
//
//  Created by James Bean on 5/28/17.
//
//

extension Meter {

    public struct Context {

        public let meter: Meter
        public let offset: MetricalDuration

        public init(meter: Meter, at offset: MetricalDuration) {
            self.meter = meter
            self.offset = offset
        }
    }
}

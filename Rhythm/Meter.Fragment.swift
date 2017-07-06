//
//  Meter.Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/6/17.
//
//

extension Meter {

    public struct Fragment {

        public let meter: Meter
        public let range: ClosedRange<MetricalDuration>

        public init(_ meter: Meter, in range: ClosedRange<MetricalDuration>) {
            self.meter = meter
            self.range = range
        }
    }
}

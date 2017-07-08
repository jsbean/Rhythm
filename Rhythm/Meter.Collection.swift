//
//  Meter.Collection.swift
//  Rhythm
//
//  Created by James Bean on 7/8/17.
//
//

import Collections

extension Meter {

    public struct Collection {

        public final class Builder {

            var meters: [Meter.Fragment] = []

            func addMeter(_ meter: Meter.Fragment) {
                self.meters.append(meter)
            }

            func addMeter(_ meter: Meter) {
                self.meters.append(Fragment(meter))
            }

            func build() -> Collection {
                return Collection(meters: meters)
            }
        }

        /// FIXME: In Swift 4, `private` can be used instead of `fileprivate`.
        fileprivate let meters: [Meter.Fragment]

        public init(meters: [Meter.Fragment]) {
            self.meters = meters
        }

        public init(meters: [Meter]) {
            self.meters = meters.map { Fragment($0) }
        }
    }
}

extension Meter.Collection: AnyCollectionWrapping {

    public var collection: AnyCollection<Meter.Fragment> {
        return AnyCollection(meters)
    }
}

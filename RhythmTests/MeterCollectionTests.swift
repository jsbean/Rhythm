//
//  MeterCollectionTests.swift
//  Rhythm
//
//  Created by James Bean on 7/8/17.
//
//

import XCTest
import Collections
import ArithmeticTools
import Rhythm

class MeterCollectionTests: XCTestCase {

    var meters: Meter.Collection {
        return Meter.Collection(
            (0..<500).map { _ -> Meter in
                let beats = Int.random(min: 3, max: 9)
                let subdivision = [16,8,4].random
                return Meter(beats,subdivision)
            }
        )
    }

    func testFragmentOutOfRange() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(13,4) ..< Fraction(14,4)]
        XCTAssert(fragment.isEmpty)
    }

    func testFragmentRangeWithinSingleMeter() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(5,4) ..< Fraction(6,4)]
        let expected = [Meter.Fragment(Meter(3,4), in: Fraction(1,4)..<Fraction(2,4))]
        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }

    func testTruncatingFragment() {

        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(2,4) ..< Fraction(9,4)]

        let expected = [
            Meter.Fragment(Meter(4,4), in: Fraction(2,4)..<Fraction(4,4)),
            Meter.Fragment(Meter(3,4)),
            Meter.Fragment(Meter(5,4), in: Fraction(0,4)..<Fraction(2,4))
        ]

        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }

    func testFragmentUpperBoundBeyondEnd() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(8,4) ..< Fraction(13,4)]
        let expected = [Meter.Fragment(Meter(5,4), in: Fraction(1,4)..<Fraction(5,4))]
        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }

    func testBeatContexts() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(2,4) ..< Fraction(9,4)]
        for beatContext in fragment.beatContexts {
            print("meter: \(beatContext.meterContext.offset): \(beatContext.meterContext.meter), \(beatContext.offset)")
        }
    }

    func testFragmentsFromTutschkuUnder() {

        let meters = Meter.Collection([
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(3,4),
            Meter(3,8),
            Meter(7,4),
            Meter(8,4),
            Meter(8,4),
            Meter(8,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,8),
            Meter(5,8),
            Meter(7,4),
            Meter(7,4),
            Meter(3,8),
            Meter(2,4),
            Meter(1,8),
            Meter(6,4),
            Meter(6,4),
            Meter(5,8),
            Meter(7,4),
            Meter(1,8),
            Meter(7,4),
            Meter(5,8),
            Meter(2,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,8),
            Meter(2,4),
            Meter(5,8),
            Meter(7,4),
            Meter(3,8),
            Meter(1,8),
            Meter(7,4),
            Meter(1,8),
            Meter(2,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(6,4),
            Meter(7,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(3,4),
            Meter(4,4),
            Meter(5,4),
            Meter(7,4),
            Meter(6,4),
            Meter(7,4),
            Meter(7,4),
            Meter(3,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(6,4),
            Meter(5,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(6,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(6,4),
            Meter(3,4),
            Meter(5,4),
            Meter(7,4),
            Meter(3,4),
            Meter(1,4),
            Meter(5,4),
            Meter(7,4),
            Meter(1,4),
            Meter(7,4),
            Meter(2,4),
            Meter(5,4),
            Meter(3,4),
            Meter(1,4),
            Meter(7,4),
            Meter(2,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(3,4),
            Meter(5,4),
            Meter(1,4),
            Meter(7,4),
            Meter(3,4),
            Meter(7,4),
            Meter(5,4),
            Meter(2,4),
            Meter(4,4),
            Meter(4,4),
            Meter(6,4),
            Meter(2,4),
            Meter(8,4),
            Meter(8,4),
            Meter(1,4),
            Meter(4,4),
            Meter(2,4),
            Meter(5,4),
            Meter(4,4),
            Meter(1,4),
            Meter(4,4),
            Meter(1,4),
            Meter(7,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(5,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(2,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(3,4),
            Meter(7,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(5,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4)
        ])

        let eventOffsets = [
            MetricalDuration(0,8),
            MetricalDuration(31,8),
            MetricalDuration(69,8),
            MetricalDuration(99,8),
            MetricalDuration(127,8),
            MetricalDuration(147,8),
            MetricalDuration(230,8),
            MetricalDuration(288,8),
            MetricalDuration(332,8),
            MetricalDuration(356,8),
            MetricalDuration(398,8),
            MetricalDuration(416,8),
            MetricalDuration(505,8),
            MetricalDuration(561,8),
            MetricalDuration(603,8),
            MetricalDuration(643,8),
            MetricalDuration(667,8),
            MetricalDuration(691,8),
            MetricalDuration(727,8),
            MetricalDuration(751,8),
            MetricalDuration(775,8),
            MetricalDuration(801,8),
            MetricalDuration(825,8),
            MetricalDuration(851,8),
            MetricalDuration(875,8),
            MetricalDuration(901,8),
            MetricalDuration(939,8),
            MetricalDuration(965,8),
            MetricalDuration(997,8),
            MetricalDuration(1033,8),
            MetricalDuration(1069,8),
            MetricalDuration(1103,8),
            MetricalDuration(1139,8),
            MetricalDuration(1162,8),
            MetricalDuration(1175,8),
            MetricalDuration(1205,8),
            MetricalDuration(1237,8),
            MetricalDuration(1257,8),
            MetricalDuration(1293,8),
            MetricalDuration(1323,8),
            MetricalDuration(1357,8),
            MetricalDuration(1387,8),
            MetricalDuration(1419,8),
            MetricalDuration(1455,8),
            MetricalDuration(1465,8),
            MetricalDuration(1487,8),
            MetricalDuration(1497,8),
            MetricalDuration(1513,8),
            MetricalDuration(1531,8),
            MetricalDuration(1547,8),
            MetricalDuration(1565,8),
            MetricalDuration(1585,8),
            MetricalDuration(1591,8),
            MetricalDuration(1609,8),
            MetricalDuration(1675,8),
            MetricalDuration(1695,8),
            MetricalDuration(1719,8),
            MetricalDuration(1735,8),
            MetricalDuration(1756,8),
            MetricalDuration(1795,8),
            MetricalDuration(1825,8),
            MetricalDuration(1855,8),
            MetricalDuration(1895,8),
            MetricalDuration(1951,8),
            MetricalDuration(1993,8),
            MetricalDuration(2035,8)
        ]

        let ranges = (eventOffsets + meters.duration).adjacentPairs!
        let fragments = ranges.map { start, end in meters[Fraction(start)..<Fraction(end)] }
        let flattenedFragments = fragments.flatMap { fragment in fragment.map { $0.1 } }
        XCTAssertEqual(meters.count, flattenedFragments.count)
        zip(meters.map { $0.1 }, flattenedFragments).forEach { XCTAssertEqual($0, $1) }
    }
}

extension Array {

    var random: Element {
        return self[Int.random(min: startIndex, max: endIndex - 1)]
    }
}

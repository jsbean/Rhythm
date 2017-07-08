//
//  MeterCollectionTests.swift
//  Rhythm
//
//  Created by James Bean on 7/8/17.
//
//

import XCTest
import ArithmeticTools
import Rhythm

class MeterCollectionTests: XCTestCase {

    func testFragmentOutOfRange() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(13,4) ... Fraction(14,4)]
        XCTAssert(fragment.isEmpty)
    }

    func testFragmentRangeWithinSingleMeter() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(5,4) ... Fraction(6,4)]
        let expected = [Meter.Fragment(Meter(3,4), in: Fraction(1,4)...Fraction(2,4))]
        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }

    func testTruncatingFragment() {

        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(2,4) ... Fraction(9,4)]

        let expected = [
            Meter.Fragment(Meter(4,4), in: Fraction(2,4)...Fraction(4,4)),
            Meter.Fragment(Meter(3,4)),
            Meter.Fragment(Meter(5,4), in: Fraction(0,4)...Fraction(2,4))
        ]

        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }

    func testFragmentUpperBoundBeyondEnd() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(8,4) ... Fraction(13,4)]
        let expected = [Meter.Fragment(Meter(5,4), in: Fraction(1,4)...Fraction(5,4))]
        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }

    func testBeatContexts() {
        let collection = Meter.Collection([(4,4),(3,4),(5,4)].map(Meter.init))
        let fragment = collection[Fraction(2,4) ... Fraction(9,4)]
        for beatContext in fragment.beatContexts {
            print("meter: \(beatContext.meterContext.offset): \(beatContext.meterContext.meter), \(beatContext.offset)")
        }
    }
}

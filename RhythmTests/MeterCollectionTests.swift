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

    // fragment out of range
    func testFragmentOutOfRange() {
        let builder = Meter.Collection.Builder()
        [(4,4),(3,4),(5,4)].map(Meter.init).forEach(builder.addMeter)
        let collection = builder.build()
        let fragment = collection[Fraction(13,4) ... Fraction(14,4)]
        XCTAssert(fragment.isEmpty)
    }

    func testSimpleFragment() {

        let builder = Meter.Collection.Builder()
        [(4,4),(3,4),(5,4)].map(Meter.init).forEach(builder.addMeter)
        let collection = builder.build()

        let fragment = collection[Fraction(2,4) ... Fraction(9,4)]
        XCTAssertEqual(fragment.count, 3)

        let expected = [
            Meter.Fragment(Meter(4,4), in: Fraction(2,4)...Fraction(4,4)),
            Meter.Fragment(Meter(3,4)),
            Meter.Fragment(Meter(5,4), in: Fraction(0,4)...Fraction(2,4))
        ]

        XCTAssertEqual(fragment.map { $0.1 }, expected)
    }
}

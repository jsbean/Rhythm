//
//  MeterFragmentTests.swift
//  Rhythm
//
//  Created by James Bean on 7/8/17.
//
//

import XCTest
import ArithmeticTools
import Rhythm

class MeterFragmentTests: XCTestCase {

    func testCleanseRange() {

        let meter = Meter(11,16)
        let range = Fraction(4,32) ... Fraction(2,4)

        let fragment = Meter.Fragment(meter, in: range)
        XCTAssertEqual(fragment.range, range)

        // Expected: 4/32 ... 16/32
        XCTAssertEqual(fragment.range.lowerBound.numerator, 4)
        XCTAssertEqual(fragment.range.lowerBound.denominator, 32)
        XCTAssertEqual(fragment.range.upperBound.numerator, 16)
        XCTAssertEqual(fragment.range.upperBound.denominator, 32)
    }
}

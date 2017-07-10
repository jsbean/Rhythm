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

    func DISABLED_testCleanseRange() {

        let meter = Meter(11,16)
        let range = Fraction(4,32) ..< Fraction(2,4)

        let fragment = Meter.Fragment(meter, in: range)
        XCTAssertEqual(fragment.range, range)

        // Expected: 4/32 ... 16/32
        XCTAssertEqual(fragment.range.lowerBound.numerator, 4)
        XCTAssertEqual(fragment.range.lowerBound.denominator, 32)
        XCTAssertEqual(fragment.range.upperBound.numerator, 16)
        XCTAssertEqual(fragment.range.upperBound.denominator, 32)
    }

    func testBeatOffsetsSimple() {
        let fragment = Meter.Fragment(Meter(3,4))
        let expected = [Fraction(0,4), Fraction(1,4), Fraction(2,4)]
        XCTAssertEqual(fragment.beatOffsets, expected)
    }

    func testBeatOffsetsWithRange() {
        let meter = Meter(11,16)
        let range = Fraction(7,32) ..< Fraction(16,32)
        let fragment = Meter.Fragment(meter, in: range)
        let expected = (0..<9).map { Fraction($0,32) }
        XCTAssertEqual(fragment.beatOffsets, expected)
    }
}

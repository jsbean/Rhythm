//
//  TempoTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import XCTest
import Collections
import ArithmeticTools
@testable import Rhythm

class InterpolationTests: XCTestCase {

    func testTempoLinear() {

        let interp = Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 1 /> 1,
            easing: Interpolation.Easing.linear)

        XCTAssertEqual(interp.tempo(at: 0 /> 1), Tempo(60))
        XCTAssertEqualWithAccuracy(
            interp.tempo(at: 1 /> 2).beatsPerMinute,
            Tempo(84.85).beatsPerMinute,
            accuracy: 0.01)
        XCTAssertEqual(interp.tempo(at: 1 /> 1), Tempo(120))
    }

    func testTempoPowerIn() {

        let interp = Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 1 /> 1,
            easing: Interpolation.Easing.powerIn(exponent: 2))

        XCTAssertEqual(interp.tempo(at: 0 /> 1), Tempo(60))
        XCTAssertEqualWithAccuracy(
            interp.tempo(at: 1 /> 2).beatsPerMinute,
            Tempo(71.35).beatsPerMinute,
            accuracy: 0.01)
        XCTAssertEqual(interp.tempo(at: 1 /> 1), Tempo(120))
    }


}

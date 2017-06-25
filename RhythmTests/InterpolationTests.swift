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

    func testTempoLinear_60to120() {

        let interp = Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 1 /> 1,
            easing: Interpolation.Easing.linear)

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds = [60, 71.35, 84.85, 100.91, 120]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqualWithAccuracy(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn2_60to120() {

        let interp = Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 1 /> 1,
            easing: Interpolation.Easing.powerIn(exponent: 2))

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds = [60, 62.66, 71.35, 88.61, 120]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqualWithAccuracy(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn3_60to120() {

        let interp = Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 1 /> 1,
            easing: Interpolation.Easing.powerIn(exponent: 3))

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds = [ 60, 60.65, 65.43, 80.38, 120 ]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqualWithAccuracy(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoLinear_120to60() {

        let interp = Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            duration: 1 /> 1,
            easing: Interpolation.Easing.linear)

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds = [120, 100.91, 84.85, 71.35, 60]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqualWithAccuracy(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn2_120to60() {

        let interp = Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            duration: 1 /> 1,
            easing: Interpolation.Easing.powerIn(exponent: 2))

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds = [ 120, 114.91, 100.90, 81.25, 60 ]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqualWithAccuracy(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testTempoPowerIn3_120to60() {

        let interp = Interpolation(
            start: Tempo(120),
            end: Tempo(60),
            duration: 1 /> 1,
            easing: Interpolation.Easing.powerIn(exponent: 3))

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds = [ 120, 118.70, 110.04, 89.57, 60 ]

        for (offset, expected) in zip(offsets, expecteds) {
            let bpmAtOffset = interp.tempo(at: offset).beatsPerMinute
            XCTAssertEqualWithAccuracy(bpmAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_60to60() {

        let interp = Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            duration: 1 /> 1,
            easing: Interpolation.Easing.linear)

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds : [Double] = [0, 1, 2, 3, 4]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(metricalOffset: offset)
            XCTAssertEqualWithAccuracy(secsAtOffset, expected, accuracy: 0.01)
        }
    }

    func testSecondsOffsetLinear_120to120() {

        let interp = Interpolation(
            start: Tempo(120),
            end: Tempo(120),
            duration: 1 /> 1,
            easing: Interpolation.Easing.linear)

        let offsets = [0/>1, 1/>4, 1/>2, 3/>4, 1/>1]
        let expecteds : [Double] = [0, 1/2, 1, 3/2, 2]

        for (offset, expected) in zip(offsets, expecteds) {
            let secsAtOffset = interp.secondsOffset(metricalOffset: offset)
            XCTAssertEqualWithAccuracy(secsAtOffset, expected, accuracy: 0.01)
        }
    }

}

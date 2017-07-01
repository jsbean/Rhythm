//
//  EasingEvaluateTests.swift
//  For Easing.evaluate(at: x)
//
//  Created by Brian Heim on 5/31/17.
//
//
import XCTest
@testable import Rhythm

class EasingEvaluateTests: XCTestCase {

    // MARK: General

    func testEasingErrorLessThanZero() {

        let x: Double = -0.5
        let ease = Interpolation.Easing.linear

        XCTAssertThrowsError(try ease.evaluate(at: x))
    }

    func testEasingErrorGreaterThanOne() {

        let x: Double = 1.5
        let ease = Interpolation.Easing.linear

        XCTAssertThrowsError(try ease.evaluate(at: x))
    }

    // MARK: Linear

    func testLinear() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.linear
        let expected = x

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    // MARK: - PowerIn

    func testPowerInOne() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.powerIn(exponent: 1)
        let expected = 0.5

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testPowerInTwo() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.powerIn(exponent: 2)
        let expected = 0.25

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testPowerInHalf() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.powerIn(exponent: 0.5)
        let expected = 0.70710678118 // 1 / sqrt(2)
        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqualWithAccuracy(result, expected, accuracy: 1e-6)
        } catch {
            XCTFail()
        }
    }

    func testPowerInError() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.powerIn(exponent: -2)

        XCTAssertThrowsError(try ease.evaluate(at: x))
    }

    // MARK: - PowerInOut

    func testPowerInOutOne() {

        let x: Double = 0.25
        let ease = Interpolation.Easing.powerInOut(exponent: 1)
        let expected = 0.25

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testPowerInOutTwo() {

        let ease = Interpolation.Easing.powerInOut(exponent: 2)

        XCTAssertEqual(try ease.evaluate(at: 0), 0)
        XCTAssertEqual(try ease.evaluate(at: 0.25), 0.125)
        XCTAssertEqual(try ease.evaluate(at: 0.5), 0.5)
        XCTAssertEqual(try ease.evaluate(at: 0.75), 0.875)
        XCTAssertEqual(try ease.evaluate(at: 1), 1)
    }

    func testPowerInOutThree() {

        let ease = Interpolation.Easing.powerInOut(exponent: 3)

        XCTAssertEqual(try ease.evaluate(at: 0), 0)
        XCTAssertEqual(try ease.evaluate(at: 0.25), 0.0625)
        XCTAssertEqual(try ease.evaluate(at: 0.5), 0.5)
        XCTAssertEqual(try ease.evaluate(at: 0.75), 0.9375)
        XCTAssertEqual(try ease.evaluate(at: 1), 1)
    }

    func testPowerInOutErrorNegativeExponent() {
        let ease = Interpolation.Easing.powerInOut(exponent: -2)
        XCTAssertThrowsError(try ease.evaluate(at: 0))
    }

    func testPowerInOutErrorPositiveExponent() {
        let ease = Interpolation.Easing.powerInOut(exponent: 0.5)
        XCTAssertThrowsError(try ease.evaluate(at: 0))
    }

    // MARK: - SineInOut

    func testSineInOut() {
        let ease = Interpolation.Easing.sineInOut
        let inputs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let sqrt2_recip = 1 / sqrt(2)
        let expecteds: [Double] = [
            0,
            (1 - sqrt2_recip) / 2,
            0.5,
            (1 + sqrt2_recip) / 2,
            1
        ]

        for (input, expected) in zip(inputs, expecteds) {
            XCTAssertEqualWithAccuracy(try ease.evaluate(at: input), expected, accuracy: 1e-12)
        }
    }
}

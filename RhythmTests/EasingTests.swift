//
//  EasingTests.swift
//  Rhythm
//
//  Created by Brian Heim on 5/31/17.
//
//

import XCTest
@testable import Rhythm

class EasingTests: XCTestCase {

    //****** General errors *******//

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

    //****** linear *******//

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

    //****** exponentialIn *******//

    func testExponentialInOne() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.exponentialIn(exponent: 1)
        let expected = 0.5

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testExponentialInTwo() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.exponentialIn(exponent: 2)
        let expected = 0.25

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testExponentialInHalf() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.exponentialIn(exponent: 0.5)
        let expected = 0.70710678118 // 1 / sqrt(2)

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqualWithAccuracy(result, expected, accuracy: 1e-6)
        } catch {
            XCTFail()
        }
    }

    func testExponentialInError() {

        let x: Double = 0.5
        let ease = Interpolation.Easing.exponentialIn(exponent: -2)

        XCTAssertThrowsError(try ease.evaluate(at: x))
    }

    //****** exponentialInOut *******//

    func testExponentialInOutOne() {

        let x: Double = 0.25
        let ease = Interpolation.Easing.exponentialInOut(exponent: 1)
        let expected = 0.25

        do {
            let result = try ease.evaluate(at: x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testExponentialInOutTwo() {

        let ease = Interpolation.Easing.exponentialInOut(exponent: 2)

        XCTAssertEqual(try ease.evaluate(at: 0), 0)
        XCTAssertEqual(try ease.evaluate(at: 0.25), 0.125)
        XCTAssertEqual(try ease.evaluate(at: 0.5), 0.5)
        XCTAssertEqual(try ease.evaluate(at: 0.75), 0.875)
        XCTAssertEqual(try ease.evaluate(at: 1), 1)
    }

    func testExponentialInOutThree() {

        let ease = Interpolation.Easing.exponentialInOut(exponent: 3)

        XCTAssertEqual(try ease.evaluate(at: 0), 0)
        XCTAssertEqual(try ease.evaluate(at: 0.25), 0.0625)
        XCTAssertEqual(try ease.evaluate(at: 0.5), 0.5)
        XCTAssertEqual(try ease.evaluate(at: 0.75), 0.9375)
        XCTAssertEqual(try ease.evaluate(at: 1), 1)
    }


    func testExponentialInOutError() {
        XCTAssertThrowsError(try Interpolation.Easing.exponentialInOut(exponent: -2).evaluate(at: 0))
        XCTAssertThrowsError(try Interpolation.Easing.exponentialInOut(exponent: 0.5).evaluate(at: 0))
    }

    //****** sineInOut *******//

    func testSineInOut() {

        let ease = Interpolation.Easing.sineInOut

        XCTAssertEqual(try ease.evaluate(at: 0), 0)
        XCTAssertEqualWithAccuracy(try ease.evaluate(at: 0.25), (1 - 1/sqrt(2)) / 2, accuracy: 1e-12)
        XCTAssertEqualWithAccuracy(try ease.evaluate(at: 0.5), 0.5, accuracy: 1e-12)
        XCTAssertEqualWithAccuracy(try ease.evaluate(at: 0.75), (1 + 1/sqrt(2)) / 2, accuracy: 1e-12)
        XCTAssertEqual(try ease.evaluate(at: 1), 1)
    }

}
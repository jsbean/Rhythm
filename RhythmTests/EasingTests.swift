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


}

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

    // MARK: - ExponentialIn

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

    // MARK: - ExponentialInOut

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


    func testExponentialInOutEvaluateAtZeroErrorNegativeExponent() {
        let ease = Interpolation.Easing.exponentialInOut(exponent: -2)
        XCTAssertThrowsError(try ease.evaluate(at: 0))
    }
    
    func testExponentialInOutEvaluateAtZeroErrorPositiveExponent() {
        let ease = Interpolation.Easing.exponentialInOut(exponent: 0.5)
        XCTAssertThrowsError(try ease.evaluate(at: 0))
    }

    // MARK: - SineInOut

    func testSineInOutEvaluateAtZero() {
        let ease = Interpolation.Easing.sineInOut
        XCTAssertEqual(try ease.evaluate(at: 0), 0)
    }
    
    func testSineInOutEvaluateAtQuarter() {
        
        let ease = Interpolation.Easing.sineInOut
        let result = try! ease.evaluate(at: 0.25)
        let expected = (1 - 1/sqrt(2)) / 2
        
        XCTAssertEqualWithAccuracy(result, expected, accuracy: 1e-12)
    }
    
    func testSineInOutEvaluateAtHalf() {
        
        let ease = Interpolation.Easing.sineInOut
        let result = try! ease.evaluate(at: 0.5)
        let expected = 0.5
        
        XCTAssertEqualWithAccuracy(result, expected, accuracy: 1e-12)
    }
    
    func testSineInOutEvaluateAtThreeQuarters() {
        
        let ease = Interpolation.Easing.sineInOut
        let result = try! ease.evaluate(at: 0.75)
        let expected = (1 + 1/sqrt(2)) / 2
        
        XCTAssertEqualWithAccuracy(result, expected, accuracy: 1e-12)
    }
    
    func testSineInOutEvaluateAtOne() {
        let ease = Interpolation.Easing.sineInOut
        XCTAssertEqual(try ease.evaluate(at: 1), 1)
    }
}

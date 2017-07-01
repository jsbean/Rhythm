//
//  EasingIntegrateTests.swift
//  For Easing.integrate(at: x)
//
//  Created by Brian Heim on 6/1/17.
//
//
import XCTest
@testable import Rhythm

class EasingIntegrateTests: XCTestCase {
    
    
    // MARK: General
    func testEasingErrorLessThanZero() {
        
        let x: Double = -0.5
        let ease = Interpolation.Easing.linear
        
        XCTAssertThrowsError(try ease.integrate(at: x))
    }
    
    func testEasingErrorGreaterThanOne() {
        
        let x: Double = 1.5
        let ease = Interpolation.Easing.linear
        
        XCTAssertThrowsError(try ease.integrate(at: x))
    }
    
    // MARK: Linear
    func testLinear() {
        
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 0.03125, 0.125, 0.28125, 0.5]
        let ease = Interpolation.Easing.linear
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqual(try ease.integrate(at: x), expected)
        }
    }
    
    // MARK: - PowerIn
    func testPowerInOne() {
        
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 1/32, 1/8, 9/32, 1/2]
        let ease = Interpolation.Easing.powerIn(exponent: 1)
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqual(try ease.integrate(at: x), expected)
        }
    }
    
    func testPowerInTwo() {
        
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 1/192, 1/24, 9/64, 1/3]
        let ease = Interpolation.Easing.powerIn(exponent: 2)
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqual(try ease.integrate(at: x), expected)
        }
    }
    
    func testPowerInHalf() {
        
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 1/12, 1/3/sqrt(2), sqrt(3)/4, 2/3]
        let ease = Interpolation.Easing.powerIn(exponent: 0.5)
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqualWithAccuracy(try ease.integrate(at: x), expected, accuracy: 1e-10)
        }
    }
    
    func testPowerInError() {
        
        let x: Double = 0.5
        let ease = Interpolation.Easing.powerIn(exponent: -2)
        
        XCTAssertThrowsError(try ease.integrate(at: x))
    }
    
    // MARK: - PowerInOut
    func testPowerInOutOne() {
        
        // results calculated with WolframAlpha
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 0.03125, 0.125, 0.28125, 0.5]
        let ease = Interpolation.Easing.powerInOut(exponent: 1)
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqual(try ease.integrate(at: x), expected)
        }
    }
    
    /// - TODO: replace test terms with actual fractions, increase accuracy
    func testPowerInOutTwo() {
        
        // results calculated with WolframAlpha
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 0.0104167, 0.0833333, 0.177083+0.0833333, 0.416667+0.0833333]
        let ease = Interpolation.Easing.powerInOut(exponent: 2)
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqualWithAccuracy(try ease.integrate(at: x), expected, accuracy: 1e-6)
        }
    }

    /// - TODO: replace test terms with actual fractions, increase accuracy
    func testPowerInOutThree() {
        
        // results calculated with WolframAlpha
        let xs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let ys: [Double] = [0, 0.00390625, 0.0625, 0.191406+0.0625, 0.4375+0.0625]
        let ease = Interpolation.Easing.powerInOut(exponent: 3)
        
        for (x, expected) in zip(xs, ys) {
            XCTAssertEqualWithAccuracy(try ease.integrate(at: x), expected, accuracy: 1e-6)
        }
    }

    func testPowerInOutErrorNegativeExponent() {
        let ease = Interpolation.Easing.powerInOut(exponent: -2)
        XCTAssertThrowsError(try ease.integrate(at: 0))
    }

    func testPowerInOutErrorPositiveExponent() {
        let ease = Interpolation.Easing.powerInOut(exponent: 0.5)
        XCTAssertThrowsError(try ease.integrate(at: 0))
    }
    
    // MARK: - SineInOut
    /// - TODO: replace test terms with actual fractions, increase accuracy
    func testSineInOut() {
        
        // results calculated with WolframAlpha
        let ease = Interpolation.Easing.sineInOut
        let inputs: [Double] = [0, 0.25, 0.5, 0.75, 1]
        let expecteds: [Double] = [0, 0.0124605, 0.0908451, 0.26246, 0.5]
        
        for (input, expected) in zip(inputs, expecteds) {
            XCTAssertEqualWithAccuracy(try ease.integrate(at: input), expected, accuracy: 1e-6)
        }
    }
}

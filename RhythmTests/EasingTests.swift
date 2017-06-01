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

    func testLinearSamePointsSameX() {

        let p1: (Double, Double) = (0.0, 0.0)
        let p2: (Double, Double) = (0.0, 0.0)
        let x: Double = 0.0
        let ease = Interpolation.Easing.linear
        let expected = 0.0

        do {
            let result = try ease.evaluate(p1, p2, x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testLinearSamePointsDiffEval() {

        let p1: (Double, Double) = (0.0, 0.0)
        let p2: (Double, Double) = (0.0, 0.0)
        let x: Double = 1.0
        let ease = Interpolation.Easing.linear

        XCTAssertThrowsError(try ease.evaluate(p1, p2, x))
    }

    func testLinearSameXDiffYSameEval() {

        let p1: (Double, Double) = (0.0, 0.0)
        let p2: (Double, Double) = (0.0, 1.0)
        let x: Double = 0.0
        let ease = Interpolation.Easing.linear

        XCTAssertThrowsError(try ease.evaluate(p1, p2, x))
    }

    func testLinearSameXDiffYDiffEval() {

        let p1: (Double, Double) = (0.0, 0.0)
        let p2: (Double, Double) = (0.0, 1.0)
        let x: Double = 1.0
        let ease = Interpolation.Easing.linear

        XCTAssertThrowsError(try ease.evaluate(p1, p2, x))
    }

    func testLinearInsideOne() {

        let p1 = (1.0, 1.0), p2 = (2.0, 2.0)
        let x = 1.5
        let ease = Interpolation.Easing.linear
        let expected = 1.5

        do {
            let result = try ease.evaluate(p1, p2, x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testLinearInsideHalf() {

        let p1 = (1.0, 1.0), p2 = (3.0, 2.0)
        let x = 1.5
        let ease = Interpolation.Easing.linear
        let expected = 1.25

        do {
            let result = try ease.evaluate(p1, p2, x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testLinearInsideMinusTwo() {

        let p1 = (1.0, 1.0), p2 = (3.0, -3.0)
        let x = 1.5
        let ease = Interpolation.Easing.linear
        let expected = 0.0

        do {
            let result = try ease.evaluate(p1, p2, x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

    func testLinearOutsideTwo() {

        let p1 = (1.0, 1.0), p2 = (3.0, 5.0)
        let x = 4.5
        let ease = Interpolation.Easing.linear
        let expected = 8.0

        do {
            let result = try ease.evaluate(p1, p2, x)
            XCTAssertEqual(result, expected)
        } catch {
            XCTFail()
        }
    }

}

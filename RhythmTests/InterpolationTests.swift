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

    func testInterpolationNoChange() {
        
        let interpolation = Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            duration: 4/>4
        )

        for beatOffset in 0...4 {
            let durationOffset = MetricalDuration(beatOffset, 4)
            XCTAssertEqual(
                interpolation.secondsOffset(metricalOffset: durationOffset),
                Double(beatOffset)
            )
        }
    }
    
    func testInterpolationChange() {
        
        let interpolation = Interpolation(
            start: Tempo(60),
            end: Tempo(30),
            duration: 4/>4
        )
        
        for beatOffset in 0...4 {
            let durationOffset = MetricalDuration(beatOffset, 4)
        }
    }
    
    func testIntpolationDifferentTempoSubdivisions() {
        
        let interpolation = Interpolation(
            start: Tempo(60, subdivision: 16),
            end: Tempo(60, subdivision: 8),
            duration: 4/>16
        )
        
        for beatOffset in 0...4 {
            let durationOffset = MetricalDuration(beatOffset, 16)
        }
    }
    
    func testLengthOfInterpolation() {
        
        let interpolation = Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 4/>4
        )
    }
    
    func testInterpolationTempoAtMetricalOffset() {
        let interp = Interpolation(start: Tempo(30), end: Tempo(60), duration: 4/>4)
        XCTAssertEqual(interp.tempo(at: 2/>4), Tempo(45))
    }

}

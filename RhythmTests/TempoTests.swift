//
//  TempoTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import XCTest
@testable import Rhythm

class TempoTests: XCTestCase {
    
    func testTempoRespellingSubdivision() {
        let original = Tempo(60, subdivision: 4)
        XCTAssertEqual(original.respelling(subdivision: 16), Tempo(240, subdivision: 16))
    }
    
    func testInterpolationNoChange() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            duration: 4/>4
        )

        for beatOffset in 0...4 {
            let durationOffset = MetricalDuration(beatOffset, 4)
            XCTAssertEqual(interpolation.seconds(offset: durationOffset), Double(beatOffset))
        }
    }
    
    func testInterpolationChange() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(30),
            duration: 4/>4
        )
        
        for beatOffset in 0...4 {
            let durationOffset = MetricalDuration(beatOffset, 4)
            print(interpolation.seconds(offset: durationOffset))
        }
    }
    
    func testIntpolationDifferentTempoSubdivisions() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60, subdivision: 16),
            end: Tempo(60, subdivision: 8),
            duration: 4/>16
        )
        
        for beatOffset in 0...4 {
            let durationOffset = MetricalDuration(beatOffset, 16)
            print(interpolation.seconds(offset: durationOffset))
        }
    }
    
    func testLengthOfInterpolation() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 4/>4
        )
        
        print("duration: \(interpolation.duration)")
    }
}

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
            XCTAssertEqual(
                interpolation.secondsOffset(metricalOffset: durationOffset),
                Double(beatOffset)
            )
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
        }
    }
    
    func testLengthOfInterpolation() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(120),
            duration: 4/>4
        )
    }
    
    func testStratum() {
        
        let interpolations = [
            Tempo.Interpolation(start: Tempo(60), end: Tempo(60), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(60), end: Tempo(90), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(90), end: Tempo(90), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(90), end: Tempo(60), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(60), end: Tempo(120), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(120), end: Tempo(60), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(60), end: Tempo(60), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(60), end: Tempo(30), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(30), end: Tempo(30), duration: 4/>4),
            Tempo.Interpolation(start: Tempo(30), end: Tempo(120), duration: 4/>4)
        ]
        
        // Metrical offsets of each interpolation
        let offsets = stride(from: 0, to: 40, by: 4).map { $0/>4 }
        let tempi = SortedDictionary(offsets, interpolations)
        let stratum = Tempo.Stratum(tempi: tempi)

        for beat in 0..<40 {
            let duration = beat /> 4
            print("offset at \(duration): \(stratum.secondsOffset(metricalOffset: duration))")
        }
    }
}

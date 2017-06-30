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
    
    func testStratum() {
        
        let interpolations = [
            Interpolation(start: Tempo(60), end: Tempo(30), duration: 8/>4),
            Interpolation(start: Tempo(30), end: Tempo(60), duration: 8/>4)
        ]
        
        // Metrical offsets of each interpolation
        let offsets = stride(from: 0, to: 16, by: 8).map { $0/>4 }
        let tempi = SortedDictionary(offsets, interpolations)
        let stratum = Tempo.Stratum(tempi: tempi)

        for beat in 0..<16 {
            let duration = beat /> 4
            let offset = stratum.secondsOffset(for: duration)
        }
    }
}

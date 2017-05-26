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
    
    func testInterpolationNoChange() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(60),
            duration: 4/>4
        )

        for offset in 0...4 {
            XCTAssertEqual(interpolation.seconds(offset: offset), Double(offset))
        }
    }
    
    func testInterpolationChange() {
        
        let interpolation = Tempo.Interpolation(
            start: Tempo(60),
            end: Tempo(30),
            duration: 4/>4
        )
        
        for offset in 0...4 {
            print(interpolation.seconds(offset: offset))
        }
    }
}

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
    
}


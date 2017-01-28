//
//  MetricalDurationTests.swift
//  Rhythm
//
//  Created by James Bean on 1/28/17.
//
//

import XCTest
import Rhythm

class MetricalDurationTests: XCTestCase {
    
    func testComparableReduced() {
        let a = MetricalDuration(1,8)
        let b = MetricalDuration(1,16)
        XCTAssertLessThan(b,a)
    }
}

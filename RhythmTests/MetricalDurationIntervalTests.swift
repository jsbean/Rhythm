//
//  MetricalDurationIntervalTests.swift
//  Rhythm
//
//  Created by James Bean on 1/28/17.
//
//

import XCTest
import IntervalTools
import Rhythm

class MetricalDurationIntervalTests: XCTestCase {
    
    func testEquals() {
        let a = MetricalDurationInterval(MetricalDuration(1,16), MetricalDuration(3,8))
        let b = MetricalDurationInterval(MetricalDuration(2,32), MetricalDuration(6,16))
        XCTAssertEqual(a.relationship(with: b), .equals)
    }
    
    func testEquals2() {
        let a = MetricalDuration(2,16)
        let b = MetricalDuration(1,16)
        XCTAssertNotEqual(a, b)
    }
    
    func testContains() {
        let a = MetricalDurationInterval(MetricalDuration(2,16), MetricalDuration(6,16))
        let b = MetricalDurationInterval(MetricalDuration(1,16), MetricalDuration(7,16))
        XCTAssertEqual(b.relationship(with: a), .contains)
    }
    
    func testInitOperator() {
        _ = 1/>2 => 8/>16
    }
}

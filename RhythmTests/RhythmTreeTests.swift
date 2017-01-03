//
//  RhythmTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import XCTest
import Rhythm
import Collections

class RhythmTreeTests: XCTestCase {

    func testLeaf() {
        let duration = MetricalDuration(1,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leaf = MetricalLeaf<Int>(context: context, metricalDuration: duration)
        _ = RhythmTree<Int>.leaf(leaf)
    }
    
    func testRest() {
        let duration = MetricalDuration(1,8)
        let context = MetricalContext<Int>.instance(.absence)
        let leaf = MetricalLeaf<Int>(context: context, metricalDuration: duration)
        _ = RhythmTree.leaf(leaf)
    }
}

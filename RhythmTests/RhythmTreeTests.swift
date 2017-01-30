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
        let leaf = MetricalLeaf<Int>(context, metricalDuration: duration)
        _ = RhythmTree<Int>.leaf(leaf)
    }
    
    func testRest() {
        let duration = MetricalDuration(1,8)
        let context = MetricalContext<Int>.instance(.absence)
        let leaf = MetricalLeaf<Int>(context, metricalDuration: duration)
        _ = RhythmTree.leaf(leaf)
    }
    
    func testSingleDepthTree() {
        let leavesCount = 5
        let contexts = (0..<leavesCount).map { _ in MetricalContext<Int>.instance(.event(1)) }
        let leaves = contexts.map { context in
            MetricalLeaf<Int>(context, metricalDuration: MetricalDuration(1,8))
        }
        
        let rootContext = MetricalContext<Int>.instance(.event(1))
        let rootValue = MetricalLeaf(rootContext, metricalDuration: MetricalDuration(4,8))
        
        let tree = RhythmTree(rootValue, leaves)
        print("Rhythm Tree: \(tree)")
    }
}

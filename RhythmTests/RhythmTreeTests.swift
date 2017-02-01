//
//  RhythmTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import XCTest
import Collections
import Rhythm

class RhythmTreeTests: XCTestCase {

//    func testLeaf() {
//        let duration = MetricalDuration(1,8)
//        let context = MetricalContext<Int>.instance(.event(1))
//        let node = MetricalLeaf<Int>(duration, context)
//        _ = RhythmTree<Int>.leaf(node)
//    }
//    
//    func testRest() {
//        let duration = MetricalDuration(1,8)
//        let context = MetricalContext<Int>.instance(.absence)
//        let node = MetricalLeaf<Int>(duration, context)
//        _ = RhythmTree.leaf(node)
//    }
//
//    func testTreeWithRestsAndTiesAndEvents() {
//        
//        // rest event tie rest event
//        // ()    | --  |   ()    |
//        
//        // All events are one eighth note
//        let leafDuration = MetricalDuration(1,8)
//        
//        let rest = MetricalContext<Int>.instance(.absence)
//        let event = MetricalContext<Int>.instance(.event(1))
//        let tied = MetricalContext<Int>.continuation
//        
//        let leaves = [rest, event, tied, rest, event].map { MetricalLeaf(leafDuration, $0) }
//        
//        let tree = RhythmTree(MetricalDuration(4,8), leaves)
//        print(tree)
//    }
//
//    func testSingleDepthTree() {
//        let nodesCount = 5
//        let contexts = (0..<nodesCount).map { _ in MetricalContext<Int>.instance(.event(1)) }
//        let leaves = contexts.map { context in
//            MetricalLeaf<Int>(MetricalDuration(1,8), context)
//        }
//
//        let tree = RhythmTree(MetricalDuration(4,8), leaves)
//        print("Rhythm Tree: \(tree)")
//    }
}

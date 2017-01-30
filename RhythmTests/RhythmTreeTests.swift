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

    func testLeaf() {
        let duration = MetricalDuration(1,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let node = MetricalNode<Int>(context, duration)
        _ = RhythmTree<Int>.leaf(node)
    }
    
    func testRest() {
        let duration = MetricalDuration(1,8)
        let context = MetricalContext<Int>.instance(.absence)
        let node = MetricalNode<Int>(context, duration)
        _ = RhythmTree.leaf(node)
    }
    
    func testTreeWithRestsAndTiesAndEvents() {
        
        // rest event tie rest event
        // ()    | --  |   ()    |
        
        // All events are one eighth note
        let duration = MetricalDuration(1,8)
        
        let rest = MetricalContext<Int>.instance(.absence)
        let event = MetricalContext<Int>.instance(.event(1))
        let tied = MetricalContext<Int>.continuation
        
        let leaves = [rest, event, tied, rest, event].map { MetricalNode($0, duration) }
        
        let rootNode = MetricalNode(
            MetricalContext<Int>.instance(.event(0)),
            MetricalDuration(4,8)
        )
        
        let tree = RhythmTree(rootNode, leaves)
        print(tree)
    }
    
    func testSingleDepthTree() {
        let nodesCount = 5
        let contexts = (0..<nodesCount).map { _ in MetricalContext<Int>.instance(.event(1)) }
        let leaves = contexts.map { context in
            MetricalNode<Int>(context, MetricalDuration(1,8))
        }
        
        let rootContext = MetricalContext<Int>.instance(.event(1))
        let rootNode = MetricalNode(rootContext, MetricalDuration(4,8))
        
        let tree = RhythmTree(rootNode, leaves)
        print("Rhythm Tree: \(tree)")
    }
}

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

    func testInit() {
        _ = RhythmTree(MetricalDuration(1,8))
    }
    
    func testSingleLeaf() {
        let rt = RhythmTree(MetricalDuration(1,8), [1])
        XCTAssertEqual(rt.leaves.count, 1)
    }
    
    func testMultipleLeaves() {
        let rt = RhythmTree(MetricalDuration(1,8), [1,2,3,4])
        XCTAssertEqual(rt.leaves.count, 4)
    }
    
    func testInsertLeafInLeaf() {
        let duration = MetricalDuration(1,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let rt = RhythmTree.leaf(MetricalValue(duration, context))
        
        let leafToInsert = rt
        let newRT = rt.inserting(tree: leafToInsert, at: 0)
        XCTAssertEqual(newRT.leaves.count, 1)
    }
    
    func testInsertLeafAtBeginningSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,2,3])
        
        print("original: \(rt)")
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(0,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(MetricalValue(duration, context))
        
        let newRT = rt.inserting(tree: leafToInsert, at: 0)
        
        print("new: \(newRT)")
        
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertLeafInMiddleSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,3,4])
        
        print("original: \(rt)")
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(2,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(MetricalValue(duration, context))
        
        let newRT = rt.inserting(tree: leafToInsert, at: 1)
        
        print("new: \(newRT)")
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertLeafAtEndSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,2,3])
        
        print("original: \(rt)")
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(4,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(MetricalValue(duration, context))
        
        let newRT = rt.inserting(tree: leafToInsert, at: 3)
        
        print("new: \(newRT)")
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertBranchAtBeginningSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [3,4])
        
        print("original: \(rt)")
        
        // Prepare branch to insert into original
        let duration = MetricalDuration(4,8)
        let branchToInsert = RhythmTree(duration, [1,2])

        let newRT = rt.inserting(tree: branchToInsert, at: 0)
        
        print("new: \(newRT)")
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertBranchInMiddleSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,4])
        
        print("original: \(rt)")
        
        // Prepare branch to insert into original
        let duration = MetricalDuration(4,8)
        let branchToInsert = RhythmTree(duration, [2,3])
        
        let newRT = rt.inserting(tree: branchToInsert, at: 1)
        
        print("new: \(newRT)")
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
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
    
    //
    func testSplitAtBeginning() {
        let array = [1,2,3,4,5]
        let (left, right) = array.split(at: 0)!
        XCTAssertEqual(left, [])
        XCTAssertEqual(right, [1,2,3,4,5])
    }
    
    func testSplitInMiddle() {
        let array = [1,2,3,4,5]
        let (left, right) = array.split(at: 2)!
        XCTAssertEqual(left, [1,2])
        XCTAssertEqual(right, [3,4,5])
    }
    
    func testSplitAtEnd() {
        let array = [1,2,3,4,5]
        let (left, right) = array.split(at: 5)!
        XCTAssertEqual(left, [1,2,3,4,5])
        XCTAssertEqual(right, [])
    }
}

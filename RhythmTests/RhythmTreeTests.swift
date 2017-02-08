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
        _ = RhythmTree(MetricalDuration(1,8), [1,2,3,4])
    }
    
    func testSingleLeaf() {
        let rt = RhythmTree(1/>8, [1])
        XCTAssertEqual(rt.leaves.count, 1)
    }
    
    func testMultipleLeaves() {
        let rt = RhythmTree(1/>8, [1,2,3,4])
        XCTAssertEqual(rt.leaves.count, 4)
    }
    
    func testInitWithRelativeDurations() {
        let rt = 1/>8 << [1,2,3,4,1] // sum: 11, should turn container to 11:8[64]
        switch rt {
        case .leaf:
            XCTFail()
        case .branch(let duration, _):
            XCTAssertEqual(duration, 8/>64)
        }
    }
    
    func testInitWithRelativeDurations13Over12() {
        let rt = 3/>16 << [2,4,3,2,2]
        switch rt {
        case .leaf:
            XCTFail()
        case .branch(let duration, _):
            XCTAssertEqual(duration, 12/>64)
        }
    }
    
    func testInitWithRelativeDurations8Over5() {
        
        let rt = 5/>8 << [1,1]
        
        guard case .branch(_, let trees) = rt else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(trees.map { $0.metricalDuration }, [2/>8, 2/>8])
        
    }
    
    func testInitWithRelativeDurations5Over4() {
        let rt = 8/>64 << [2,2,1]
        switch rt {
        case .leaf:
            XCTFail()
        case .branch(let duration, let trees):
            
            // assert 8 is matched downwards to 4/32
            break
        }
    }
    
    func testWithMetricalDurationLeaf() {
        
        let originalDuration = 1/>8
        let leaf = RhythmTree.leaf(originalDuration, .instance(.event(1)))
        
        let newDuration = 1/>8
        let newLeaf = leaf.with(metricalDuration: newDuration)

        switch newLeaf {
        case .branch:
            XCTFail()
        case .leaf(let duration, let context):
            XCTAssertEqual(duration, newDuration)
        }
    }
    
    func testWithMetricalDurationBranchSumLessThanNumerator() {
        
    }
    
    func testInsertLeafInLeaf() {
        let context = MetricalContext<Int>.instance(.event(1))
        let rt = RhythmTree.leaf(1/>8, context)
        
        let leafToInsert = rt
        let newRT = try! rt.inserting(tree: leafToInsert, at: 0)
        XCTAssertEqual(newRT.leaves.count, 1)
    }
    
    func testInsertLeafAtBeginningSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,2,3])
        
        print("original: \(rt)")
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(0,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(duration, context)
        
        let newRT = try! rt.inserting(tree: leafToInsert, at: 0)
        
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
        let leafToInsert = RhythmTree.leaf(duration, context)
        
        let newRT = try! rt.inserting(tree: leafToInsert, at: 1)
        
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
        let leafToInsert = RhythmTree.leaf(duration, context)
        
        let newRT = try! rt.inserting(tree: leafToInsert, at: 3)
        
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

        let newRT = try! rt.inserting(tree: branchToInsert, at: 0)
        
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
        
        let newRT = try! rt.inserting(tree: branchToInsert, at: 1)
        
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
    
    func testMetricalLeafRestOperator() {
        let rt = 1/>8 << [1,1,2,1]
        XCTAssertEqual(rt.leaves.count, 4)
    }
    
    // TODO: Move these to `Collections` with `split(at:)`
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

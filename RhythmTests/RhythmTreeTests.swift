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
        
        guard case .branch(let duration, _) = rt else {
            XCTFail()
            return
        }

        XCTAssertEqual(duration, 8/>64)
    }
    
    func testInitWithRelativeDurations13Over12() {
        
        let rt = 3/>16 << [2,4,3,2,2]
        
        guard case .branch(let duration, _) = rt else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(duration, 12/>64)
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
        
        guard case .branch(let duration, _) = rt else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(duration, 8/>64)
    }
    
    func testWithMetricalDurationLeaf() {
        
        let originalDuration = 1/>8
        let leaf = RhythmTree.leaf(originalDuration, .instance(.event(1)))
        
        let newDuration = 1/>8
        let newLeaf = leaf.with(metricalDuration: newDuration)

        XCTAssertEqual(newLeaf.metricalDuration, newDuration)
    }
    
    func testInsertLeafInLeaf() {
        
        let rt = RhythmTree.leaf(1/>8, MetricalContext<Int>.instance(.event(1)))
        
        let leafToInsert = rt
        let newRT = try! rt.inserting(tree: leafToInsert, at: 0)
        
        XCTAssertEqual(newRT.leaves.count, 1)
    }
    
    func testInsertLeafAtBeginningSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,2,3])
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(0,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(duration, context)
        
        let newRT = try! rt.inserting(tree: leafToInsert, at: 0)
        
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertLeafInMiddleSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,3,4])
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(2,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(duration, context)
        
        let newRT = try! rt.inserting(tree: leafToInsert, at: 1)

        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertLeafAtEndSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,2,3])
        
        // Prepare leaf to insert into original
        let duration = MetricalDuration(4,8)
        let context = MetricalContext<Int>.instance(.event(1))
        let leafToInsert = RhythmTree.leaf(duration, context)
        
        let newRT = try! rt.inserting(tree: leafToInsert, at: 3)
        
        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertBranchAtBeginningSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [3,4])
        
        // Prepare branch to insert into original
        let duration = MetricalDuration(4,8)
        let branchToInsert = RhythmTree(duration, [1,2])

        let newRT = try! rt.inserting(tree: branchToInsert, at: 0)

        XCTAssertEqual(newRT.leaves.count, 4)
    }
    
    func testInsertBranchInMiddleSingleDepthBranch() {
        
        // Original `RhythmTree`
        let rt = RhythmTree(MetricalDuration(1,8), [1,4])
        
        // Prepare branch to insert into original
        let duration = MetricalDuration(4,8)
        let branchToInsert = RhythmTree(duration, [2,3])
        
        let newRT = try! rt.inserting(tree: branchToInsert, at: 1)
        
        XCTAssertEqual(newRT.leaves.count, 4)
    }
}

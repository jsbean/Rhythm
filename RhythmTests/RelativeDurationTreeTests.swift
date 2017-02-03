//
//  RelativeDurationTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import XCTest
import Rhythm

class RelativeDurationTreeTests: XCTestCase {
    
    func testInit() {
        _ = RelativeDurationTree.branch(1, [.leaf(1), .leaf(2), .leaf(2)])
    }
    
    func testMapLeaf() {
        
        let leaf = RelativeDurationTree.leaf(1)
        XCTAssertEqual(map(leaf) { $0 * 10 }.value, 10)
    }
    
    func testMapBranch() {
        
        let branch = RelativeDurationTree.branch(1, [
            .leaf(1),
            .leaf(2),
            .leaf(3)
        ])
        
        XCTAssertEqual(map(branch) { $0 * 10 }.value, 10)
    }
    
    func testNormalizeSingleDepth() {
        
        let tree = RelativeDurationTree.branch(1, [
            .leaf(2),
            .leaf(3)
        ])
        
        XCTAssertEqual(try normalized(tree).value, 4)
    }
    
    func testUpdatingValueOfTreeAtIndex() {
        
        let tree = RelativeDurationTree.branch(1, [
            .leaf(2),
            .leaf(3)
        ])
        
        let newTree = try! updating(value: 8, ofTreeAt: 0, of: tree)
        XCTAssertEqual(newTree.leaves, [8,12])
    }
    
    func testNormalizeNested() {
        
        let tree = RelativeDurationTree.branch(1, [
            .branch(2, [
                .leaf(2),
                .leaf(4),
                .leaf(1)
            ]),
            .leaf(3)
        ])
        
        let new = try! normalized(tree)
        XCTAssertEqual(new.value, 16)
    }
    
    func testNormalizedReallyNested() {
        
        let tree = RelativeDurationTree.branch(1, [
            .branch(2, [
                .leaf(2),
                .branch(3, [
                    .leaf(1),
                    .leaf(1),
                    .leaf(1),
                    .leaf(1)
                ])
            ]),
            .leaf(4),
            .branch(3, [
                .leaf(2),
                .branch(4, [
                    .leaf(2),
                    .leaf(3)
                ]),
                .leaf(1)
            ])
        ])
        
        let n = try! normalized(tree)
    }
    
    func testNormalizeBranchLiftParentToChildren() {
        
        let branch = RelativeDurationTree.branch(1, [
            .leaf(2),
            .leaf(3)
            ])
        
        XCTAssertEqual(try normalize(branch: branch).value, 4)
    }
    
    func testNormalizeBranchLiftChildrenToParent() {
        
        let branch = RelativeDurationTree.branch(8, [
            .leaf(1),
            .leaf(1),
            .leaf(1)
        ])

        switch try! normalize(branch: branch) {
        case .leaf:
            XCTFail()
        case .branch(let duration, let trees):
            XCTAssertEqual(duration, 8)
            XCTAssertEqual(trees.map { $0.value }, [2,2,2])
        }
    }
}

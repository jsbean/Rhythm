//
//  RelativeDurationTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import XCTest
import Collections
@testable import Rhythm

class RelativeDurationTreeTests: XCTestCase {
    
    func testInit() {
        _ = RelativeDurationTree.branch(1, [.leaf(1), .leaf(2), .leaf(2)])
    }
    
    func testReducedSingleDepth() {
        
        let tree = RelativeDurationTree.branch(1, [
            .leaf(2),
            .leaf(4),
            .leaf(6)
        ])
        
        XCTAssertEqual(reduced(tree).leaves, [1,2,3])
    }
    
    func testReducedNested() {
        
        let tree = RelativeDurationTree.branch(1, [
            .leaf(2),
            .branch(4, [
                .leaf(6),
                .leaf(2),
                .leaf(4)
            ]),
            .leaf(8)
        ])
        
        XCTAssertEqual(reduced(tree).leaves, [1,3,1,2,4])
    }

    func testDistanceNested() {
        
        let tree = RelativeDurationTree.branch(1, [
            .leaf(2),
            .branch(4, [
                .leaf(6),
                .leaf(2),
                .leaf(4)
            ]),
            .leaf(8)
        ])
        
        let expected = RelativeDurationTree.branch(3, [
            .leaf(0),
            .branch(1, [
                .leaf(0),
                .leaf(0),
                .leaf(0)
            ]),
            .leaf(0)
        ])
        
        let result = distanceTree(original: tree, new: liftParentsToMatchChildren(tree))
        XCTAssert(result == expected)
    }
    
    func testDistanceByLevelSingleDepth() {
        
        let distanceTree = RelativeDurationTree.branch(2, [
            .leaf(0),
            .leaf(0),
            .leaf(0)
        ])
        
        XCTAssertEqual(distanceByLevel(distanceTree), [2, 0])
    }

    func testDistanceByLevelNested() {
        
        let distanceTree = RelativeDurationTree.branch(3, [
            .leaf(0),
            .branch(1, [
                .leaf(0),
                .leaf(0),
                .leaf(0)
            ]),
            .leaf(0)
        ])
        
        XCTAssertEqual(distanceByLevel(distanceTree), [3, 1, 0])
    }
    
    func testPropagated() {
        XCTAssertEqual(propagate([1,0,2,4]), [7,6,6,4])
    }
    
    /// Move to Collections extension
    func testMaxByIndex() {
        
        let a = [1,2,3]
        let b = [0,1,2,3,4]
        let c = [-1,4,0,2]
        let d: [Int] = []
        let e = [4,0,6,0,8,1]
        
        let expected = [4,4,6,3,8,1]
        
        XCTAssertEqual(maxByIndex([a,b,c,d,e]), expected)
    }
    
    func testNormalizedReallyFucked() {
        
        let tree = Tree.branch(1, [
            .branch(2, [
                .leaf(16),
                .leaf(24)
            ]),
            .branch(4, [
                .leaf(3),
                .leaf(4),
                .branch(6, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(2),
                .branch(2, [
                    .leaf(3),
                    .leaf(5)
                ])
            ]),
            .branch(3, [
                .leaf(2),
                .leaf(4),
                .branch(1, [
                    .leaf(32),
                    .leaf(34)
                ])
            ])
        ])
        
        let expected = Tree.branch(512, [
            .branch(128, [
                .leaf(64),
                .leaf(96)
            ]),
            .branch(256, [
                .leaf(48),
                .leaf(64),
                .branch(96, [
                    .leaf(32),
                    .leaf(32)
                ]),
                .leaf(32),
                .branch(32, [
                    .leaf(12),
                    .leaf(20)
                ])
            ]),
            .branch(192, [
                .leaf(32),
                .leaf(64),
                .branch(16, [
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])
        
        XCTAssert(normalized(tree) == expected)
    }
    
    func testNormalizedNested() {
        
        let tree = Tree.branch(1, [
            .branch(2, [
                .leaf(3),
                .leaf(2)
            ]),
            .leaf(4),
            .branch(3, [
                .leaf(2),
                .branch(4, [
                    .leaf(4),
                    .leaf(3)
                ]),
                .leaf(1)
            ])
        ])
        
        let expected = Tree.branch(32, [
            .branch(8, [
                .leaf(6),
                .leaf(4)
            ]),
            .leaf(16),
            .branch(12, [
                .leaf(4),
                .branch(8, [
                    .leaf(4),
                    .leaf(3)
                ]),
                .leaf(2)
            ])
        ])
        
        print(normalized(tree))
        
        XCTAssert(normalized(tree) == expected)
    }
    
    func testMatchLeavesLeaf() {
        XCTAssert(liftLeavesToMatchParent(.leaf(1)) == .leaf(1))
    }
    
    func testMatchLeavesSingleDepth() {
        
        let tree = Tree.branch(32, [
            .leaf(2),
            .leaf(3)
        ])
        
        XCTAssertEqual(liftLeavesToMatchParent(tree).leaves, [16,24])
    }
    
    func testMatchLeavesNested() {
        
        let tree = Tree.branch(24, [
            .branch(16, [
                .leaf(2),
                .leaf(3)
            ]),
            .branch(64, [
                .leaf(1),
                .leaf(4),
                .leaf(2)
            ])
        ])
        
        XCTAssertEqual(liftLeavesToMatchParent(tree).leaves, [8,12,8,32,16])
    }
}

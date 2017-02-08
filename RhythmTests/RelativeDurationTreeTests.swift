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
    
    var veryNested: RelativeDurationTree {
        
        return Tree.branch(1, [
            .branch(2, [
                .branch(16, [
                    .leaf(1),
                    .leaf(1)
                ]),
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
    }
    
    func testInit() {
        _ = RelativeDurationTree.branch(1, [.leaf(1), .leaf(2), .leaf(2)])
    }
    
    func testReducedSingleDepth() {
        
        let tree = RelativeDurationTree.branch(1, [
            .leaf(2),
            .leaf(4),
            .leaf(6)
        ])
        
        XCTAssertEqual(reducingSiblings(tree).leaves, [1,2,3])
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
        
        XCTAssertEqual(reducingSiblings(tree).leaves, [1,3,1,2,4])
    }
    
    func testReducedVeryNested() {
        
        let result = veryNested |> reducingSiblings
        
        let expected = Tree.branch(1, [
            .branch(2, [
                .branch(2, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(3)
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
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])
        
        XCTAssert(result == expected)
    }
    
    func testmatchingParentsToChildrenSingleDepthDown() {
        
        let tree = Tree.branch(6, [
            .leaf(1),
            .leaf(1)
        ])
        
        XCTAssertEqual(matchingParentsToChildren(tree).value, 3)
    }
    
    func testmatchingParentsToChildrenSingleDepthUp() {
        
        let tree = Tree.branch(1, [
            .leaf(8),
            .leaf(3)
        ])
        
        XCTAssertEqual(matchingParentsToChildren(tree).value, 8)
    }
    
    func testMatchParentsVeryNestedMultipleCases() {
        
        let result = veryNested |> reducingSiblings |> matchingParentsToChildren
        
        let expected = Tree.branch(8, [
            .branch(4, [
                .branch(2, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(3)
            ]),
            .branch(16, [
                .leaf(3),
                .leaf(4),
                .branch(3, [
                    .leaf(1),
                    .leaf(1)
                ]),
                .leaf(2),
                .branch(8, [
                    .leaf(3),
                    .leaf(5)
                ])
            ]),
            .branch(6, [
                .leaf(2),
                .leaf(4),
                .branch(32, [
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])

        XCTAssert(result == expected)
    }
    
    func testPropagatedDistanceTreeVeryNested() {
        
        let distanceTree = Tree.branch(3, [
            .branch(1, [
                .branch(0, [
                    .leaf(0),
                    .leaf(0)
                    ]),
                .leaf(0)
            ]),
            .branch(2, [
                .leaf(0),
                .leaf(0),
                .branch(-1, [
                    .leaf(0),
                    .leaf(0)
                    ]),
                .leaf(0),
                .branch(2, [
                    .leaf(0),
                    .leaf(0)
                ])
            ]),
            .branch(1, [
                .leaf(0),
                .leaf(0),
                .branch(5, [
                    .leaf(0),
                    .leaf(0)
                ])
            ])
        ])
        
        let expected = Tree.branch(9, [
            .branch(6, [
                .branch(5, [
                    .leaf(5),
                    .leaf(5)
                ]),
                .leaf(5)
            ]),
            .branch(6, [
                .leaf(4),
                .leaf(4),
                .branch(4, [
                    .leaf(5),
                    .leaf(5)
                ]),
                .leaf(4),
                .branch(4, [
                    .leaf(2),
                    .leaf(2)
                ])
            ]),
            .branch(6, [
                .leaf(5),
                .leaf(5),
                .branch(5, [
                    .leaf(0),
                    .leaf(0)
                ])
            ])
        ])
        
        let result = distanceTree |> propagated
        XCTAssert(result == expected)
    }
    
    func testNormalizeVeryNested() {
    
        let expected = Tree.branch(512, [
            .branch(128, [
                .branch(64, [
                    .leaf(32),
                    .leaf(32)
                ]),
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
                .leaf(64),
                .leaf(128),
                .branch(32, [
                    .leaf(16),
                    .leaf(17)
                ])
            ])
        ])
        
        let result = normalized(veryNested)
        XCTAssert(result == expected)
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

        XCTAssert(normalized(tree) == expected)
    }
}

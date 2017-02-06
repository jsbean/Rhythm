//
//  RelativeDurationTreeTests.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import XCTest
import Collections
import Rhythm

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
    
    func testNormalizeNested() {
        
        let tree = RelativeDurationTree.branch(1, [
            .branch(2, [
                .leaf(2),
                .leaf(3)
            ]),
            .branch(4, [
                .leaf(3),
                .branch(4, [
                    .leaf(4),
                    .leaf(3)
                ]),
                .leaf(6),
                .leaf(2),
                .leaf(2)
            ]),
            .branch(3, [
                .leaf(2),
                .leaf(4),
                .leaf(1)
            ])
        ])
        
        let sanitized = try normalized(tree)
    }
    
//    func testNormalizeSingleDepth() {
//        
//        let tree = RelativeDurationTree.branch(1, [
//            .leaf(2),
//            .leaf(3)
//        ])
//        
//        XCTAssertEqual(normalized(tree).value, 4)
//    }
//    
//    func testNormalizedTripleBringParentUp() {
//        
//        let tree = RelativeDurationTree.branch(1, [
//            .leaf(1),
//            .leaf(1),
//            .leaf(1)
//        ])
//        
//        XCTAssertEqual(normalized(tree).value, 2)
//    }
//    
////    func testNormalizedTripleBigParent() {
////        
////        let tree = RelativeDurationTree.branch(16, [
////            .leaf(1),
////            .leaf(1),
////            .leaf(1)
////        ])
////        
////        XCTAssertEqual(normalized(tree).value, 2)
////    }
//    
//    func testNormalizeNested() {
//        
//        let tree = RelativeDurationTree.branch(1, [
//            .branch(2, [
//                .leaf(2),
//                .leaf(4),
//                .leaf(1)
//            ]),
//            .leaf(3)
//        ])
//        
//        let new = normalized(tree)
//        XCTAssertEqual(new.value, 16)
//    }
//    
//    func testNormalizedReallyNested() {
//        
//        let tree = RelativeDurationTree.branch(1, [
//            .branch(2, [
//                .leaf(2),
//                .branch(3, [
//                    .leaf(1),
//                    .leaf(1),
//                    .leaf(1),
//                    .leaf(1)
//                ])
//            ]),
//            .leaf(4),
//            .branch(3, [
//                .leaf(2),
//                .branch(4, [
//                    .leaf(2),
//                    .leaf(3)
//                ]),
//                .leaf(1)
//            ])
//        ])
//        
//        let expected = RelativeDurationTree.branch(16, [
//            .branch(4, [
//                .leaf(2),
//                .branch(3, [
//                    .leaf(1),
//                    .leaf(1),
//                    .leaf(1),
//                    .leaf(1)
//                ])
//            ]),
//            .leaf(8),
//            .branch(6, [
//                .leaf(2),
//                .branch(4, [
//                    .leaf(2),
//                    .leaf(3)
//                ]),
//                .leaf(1)
//            ])
//        ])
//
//        let result = normalized(tree)
//        XCTAssert(result == expected)
//    }
}

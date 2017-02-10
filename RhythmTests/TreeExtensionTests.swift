//
//  TreeExtensionTests.swift
//  Rhythm
//
//  Created by James Bean on 2/8/17.
//
//

import XCTest
import Collections
import Rhythm

class TreeExtensionTests: XCTestCase {
    
//    func testInitSingleDepthArray() {
//        
//        let tree = Tree<Int>([1,[1,2,3]])
//        
//        let expected = Tree.branch(1, [
//            .leaf(1),
//            .leaf(2),
//            .leaf(3)
//            ])
//        
//        XCTAssert(tree == expected)
//    }
    
//    func testInitArrayNestedSimple() {
//        
//        let tree = Tree<Int>([-1,[1,[-1,[2,3,4]],5]])
//        
//        let expected = Tree.branch(-1, [
//            .leaf(1),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//                ]),
//            .leaf(5)
//            ])
//        
//        XCTAssert(tree == expected)
//    }
    
//    func testInitArrayMultipleNested() {
//        
//        let tree = Tree<Int>([-1,[[-1,[1]],[-1,[2,3,4]],5]])
//        
//        let expected = Tree.branch(-1, [
//            .branch(-1, [
//                .leaf(1)
//                ]),
//            .branch(-1, [
//                .leaf(2),
//                .leaf(3),
//                .leaf(4)
//                ]),
//            .leaf(5)
//            ])
//        
//        XCTAssert(tree == expected)
//    }
    
//    `testInitArrayVeryNested()` is deactivated because it hangs the compiler for a few
//    seconds.
//
//    Periodically reactivate to ensure nothing have regressed.
//
//    func testInitArrayVeryNested() {
//
//        let tree = try! Tree<Int>(
//            [1,[[2,[[16,[1,1]],24]],[4,[3,4,[6,[1,1]],2,[2,[3,5]]]],[3,[2,4,[1,[32,34]]]]]]
//        )
//
//        let expected = Tree.branch(1, [
//            .branch(2, [
//                .branch(16, [
//                    .leaf(1),
//                    .leaf(1)
//                ]),
//                .leaf(24)
//            ]),
//            .branch(4, [
//                .leaf(3),
//                .leaf(4),
//                .branch(6, [
//                    .leaf(1),
//                    .leaf(1)
//                ]),
//                .leaf(2),
//                .branch(2, [
//                    .leaf(3),
//                    .leaf(5)
//                ])
//            ]),
//            .branch(3, [
//                .leaf(2),
//                .leaf(4),
//                .branch(1, [
//                    .leaf(32),
//                    .leaf(34)
//                ])
//            ])
//        ])
//        
//        XCTAssert(tree == expected)
//    }
}

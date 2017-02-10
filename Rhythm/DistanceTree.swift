//
//  DistanceTree.swift
//  Rhythm
//
//  Created by James Bean on 2/9/17.
//
//

import Collections

/// Tree recording the change (in degree of power-of-two) needed to correct a node in a
/// `ProprtionTree`.
internal typealias DistanceTree = Tree<Int>

extension Tree where T == Int {
    
    /// - returns: `DistanceTree` with distances propagated up and down.
    ///
    /// - TODO: Not convinced by implementation of `propogateDown`.
    internal var propagated: DistanceTree {
        
        /// Propagate up and accumulate the maximum of the sums of children values
        func propagateUp(_ tree: DistanceTree) -> DistanceTree {
            
            guard case .branch(let value, let trees) = tree else {
                return tree
            }
            
            let newTrees = trees.map(propagateUp)
            let max = newTrees.map { $0.value }.max()!
            return .branch(value + max, newTrees)
        }
        
        /// Takes in the original distance tree, and a distance tree which has already
        /// had its values propagated up to the root, as well as an inherited value which is passed
        /// along between levels.
        ///
        /// - note: Need to make inherited optional? // this smells
        func propagateDown(
            _ original: DistanceTree,
            _ propagatedUp: DistanceTree,
            inherited: Int?
        ) -> DistanceTree
        {
            
            switch (original, propagatedUp) {
                
            // If we are leaf,
            case (.leaf, .leaf):
                return .leaf(inherited!)
                
            // Replace value with inherited (if present), or already propagated
            case (.branch(let original, let oTrees), .branch(let propagated, let pTrees)):
                
                let value = inherited ?? propagated
                let subTrees = zip(oTrees, pTrees).map { o, p in
                    propagateDown(o, p, inherited: value - original)
                }
                
                return .branch(value, subTrees)
                
            // Enforce same-shaped trees
            default:
                fatalError("Incompatible trees")
            }
            
            return propagatedUp
        }
        
        let propagatedUp = propagateUp(self)
        return propagateDown(self, propagatedUp, inherited: nil)
    }
}

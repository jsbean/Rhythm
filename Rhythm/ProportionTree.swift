//
//  ProportionTree.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//  Formalized by Brian Heim.
//

import Foundation
import Collections
import ArithmeticTools

/// Similar to the proportional aspect to the `OpenMusic` `Rhythm Tree` structure. 
public typealias ProportionTree = Tree<Int>

extension Tree where T == Int {
    
    /// - returns: A new `ProportionTree` in which the value of each node can be represented
    /// with the same subdivision-level (denominator).
    public var normalized: ProportionTree {
        
        // Reduce each level of children by their `gcd`
        let siblingsReduced = self.reducingSiblings
        
        // Match parent values to the closest power-of-two to the sum of their children values.
        let parentsMatched = siblingsReduced.matchingParentsToChildren
        
        // Generate a tree which contains the values necessary to multiply each node of a
        // `reduced` tree to properly match the values in a `parentsMatched` tree.
        let distances = zip(siblingsReduced, parentsMatched, encodeDistance).propagated
        
        /// Multiply each value in `siblingsReduced` by the corrosponding multiplier in the
        /// `ProportionTree`.
        ///
        /// Then, ensure there are no leaves dangling unmatched to their parents.
        return zip(siblingsReduced, distances, decodeDuration).matchingChildrenToParents
    }
    
    /// - returns: A new `ProportionTree` for which each level of sub-trees is at its most
    /// reduced level (e.g., `[2,4,6] -> [1,2,3]`).
    ///
    /// - note: In the case of parents with a single child, no reduction occurs.
    internal var reducingSiblings: ProportionTree {
        
        func reduced(_ trees: [ProportionTree]) -> [ProportionTree] {
            let values = trees.map { $0.value }
            let reduced = values.map { $0 / values.gcd! }
            return zip(trees, reduced).map { $0.updating(value: $1) }
        }
        
        guard case
            .branch(let value, let trees) = self,
            trees.count > 1
        else {
            return self
        }
        
        return .branch(value, reduced(trees).map { $0.reducingSiblings } )
    }
    
    /// - returns: `ProportionTree` with the values of parents matched to the closest
    /// power-of-two of the sum of the values of their children.
    ///
    /// There are two cases where action is required:
    ///
    /// - Parent is required scaled _up_ to match the sum of its children
    /// - Parent is required scaled _down_ to match the sum of its children
    internal var matchingParentsToChildren: ProportionTree {
        
        func updateDuration(_ original: Int, _ children: [ProportionTree]) -> Int {
            let relativeDurations = children.map { $0.value }
            let sum = relativeDurations.sum
            let coefficient = original >> countTrailingZeros(original)
            return closestPowerOfTwo(withCoefficient: coefficient, to: sum)!
        }
        
        guard case .branch(let duration, let trees) = self else {
            return self
        }
        
        let newDuration = updateDuration(duration, trees)
        return .branch(newDuration, trees.map { $0.matchingParentsToChildren })
    }
    
    /// - returns: `ProportionTree` with the values of any leaves lifted to match any parents
    /// which have been lifted in previous stages of the normalization process.
    ///
    /// - note: That this is required perhaps indicates that propagation is not being handled
    /// correctly for trees of `height` 1.
    internal var matchingChildrenToParents: ProportionTree {
        
        /// Only continue if we are a parent of only leaves.
        guard case
            .branch(let duration, let trees) = self,
            self.height == 1
        else {
            return self
        }
        
        let sum = trees.map { $0.value }.sum
        
        /// If the duration of parent is greater than the sum of the children's values, our
        /// work is done.
        guard sum < duration else {
            return self
        }
        
        let multiplier = closestPowerOfTwo(withCoefficient: sum, to: duration)! / sum
        let newTrees = trees.map { $0.map { $0 * multiplier } }
        
        return .branch(duration, newTrees)
    }

    /// - returns: Relative duration value scaled by the given `distance`.
    private func decodeDuration(_ original: Int, _ distance: Int) -> Int {
        return Int(Double(original) * pow(2, Double(distance)))
    }
    
    /// - returns: Distance (in powers-of-two) from one relative durational value to another.
    private func encodeDistance(_ original: Int, _ new: Int) -> Int {
        return Int(log2(Double(new) / Double(original)))
    }
}

extension Tree where T == Int {
    
    /// Create an arbitrarily-nested tree with an array.
    ///
    /// Modeled after OpenMusic's `RhythmTree` notation.
    ///
    /// A single-depth tree looks like this:
    ///
    ///     let singleDepth = [1, [1,2,3]]
    ///
    /// A multi-depth tree looks like this:
    ///
    ///     let multiDepth = [1, [1,[2,[1,2,[3,[1,2,3]]]],3]]
    ///
    /// Good luck.
    public init(_ value: [Any]) {
        
        func traverse(_ value: Any) -> ProportionTree {
            
            // Input: `T`
            if let leaf = value as? T {
                return .leaf(leaf)
            }
            
            // Input: `[Any]`
            guard
                let branch = value as? [Any],
                let (head, tail) = branch.destructured
                else {
                    fatalError()
            }
            
            switch head {
                
            // Input: `[T, ...]`
            case let value as T:
                
                // Input: `[T]`
                if tail.isEmpty {
                    return .branch(value, branch.map(traverse))
                }
                
                // Input: `[T, [...]]`
                guard
                    tail.count == 1,
                    let children = tail.first as? [Any]
                    else {
                        fatalError()
                }
                
                return .branch(value, children.map(traverse))
                
            // Input: `[[T ... ], ... ]`
            case let branch as [Any]:
                return traverse(branch)
                
            default:
                fatalError()
            }
        }
        
        self = traverse(value)
    }
}

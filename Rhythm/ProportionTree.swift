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

/// Representation of `MetricalDuration` without specific subdivision-value (denominator).
public typealias Proportion = Int

/// Representation of the power-of-two quotient between two `RelativeDuration` values.
public typealias Distance = Int

/// Representation of relative durations.
public typealias ProportionTree = Tree<Proportion>

/// Representation of encoded distances between relative durational values.
public typealias DistanceTree = Tree<Distance>

/// - returns: A new `ProportionTree` in which the value of each node can be represented
/// with the same subdivision-level (denominator).
public func normalized(_ tree: ProportionTree) -> ProportionTree {

    // Reduce each level of children by their `gcd`
    let siblingsReduced = tree |> reducingSiblings
    
    // Match parent values to the closest power-of-two to the sum of their children values.
    let parentsMatched = siblingsReduced |> matchingParentsToChildren

    // Generate a tree which contains the values necessary to multiply each node of a
    // `reduced` tree to properly match the values in a `parentsMatched` tree.
    let distances = zip(siblingsReduced, parentsMatched, encodeDistance) |> propagated

    /// Multiply each value in `siblingsReduced` by the corrosponding multiplier in the 
    /// `distanceTree`.
    ///
    /// Then, ensure there are no leaves dangling unmatched to their parents.
    return zip(siblingsReduced, distances, decodeDuration) |> matchingChildrenToParents
}

/// - returns: A new `ProportionTree` for which each level of sub-trees is at its most
/// reduced level (e.g., `[2,4,6] -> [1,2,3]`).
///
/// - note: In the case of parents with a single child, no reduction occurs.
internal func reducingSiblings(_ tree: ProportionTree) -> ProportionTree {
    
    guard case
        .branch(let value, let trees) = tree,
        trees.count > 1
    else {
        return tree
    }
    
    let values = trees.map { $0.value }
    let reduced = values.map { $0 / values.gcd! }
    let reducedTrees = zip(trees, reduced).map { $0.updating(value: $1) }
    return .branch(value, reducedTrees.map(reducingSiblings))
}

/// - returns: `ProportionTree` with the values of parents matched to the closest
/// power-of-two of the sum of the values of their children.
///
/// There are two cases where action is required:
///
/// - Parent is required scaled _up_ to match the sum of its children
/// - Parent is required scaled _down_ to match the sum of its children
internal func matchingParentsToChildren(_ tree: ProportionTree)
    -> ProportionTree
{
    guard case .branch(let duration, let trees) = tree else {
        return tree
    }
    
    let relativeDurations = trees.map { $0.value }
    let sum = relativeDurations.sum
    
    let newDuration: Int = closestPowerOfTwo(withCoefficient: duration >> countTrailingZeros(duration), to: sum)!
    
    return .branch(newDuration, trees.map(matchingParentsToChildren))
}

/// - returns: `ProportionTree` with the values of any leaves lifted to match any parents
/// which have been lifted in previous stages of the normalization process.
///
/// - note: That this is required perhaps indicates that propagation is not being handled
/// correctly for trees of `height` 1.
internal func matchingChildrenToParents(_ tree: ProportionTree) -> ProportionTree {
    
    guard case
        .branch(let duration, let trees) = tree,
        tree.height == 1
    else {
        return tree
    }
    
    let sum = trees.map { $0.value }.sum
    
    guard sum < duration else {
        return tree
    }
    
    let multiplier = closestPowerOfTwo(withCoefficient: sum, to: duration)! / sum
    let newTrees = trees.map { $0.map { $0 * multiplier } }
    return .branch(duration, newTrees)
}

/// - returns: `DistanceTree` with distances propagated up and down.
///
/// - TODO: Not convinced by implementation of `propogateDown`.
internal func propagated(_ tree: DistanceTree) -> DistanceTree {

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
    func propagateDown(_ original: DistanceTree, _ propagatedUp: DistanceTree, inherited: Int?)
        -> DistanceTree
    {

        switch (original, propagatedUp) {
            
        // Accept what's given
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
    
    let propagatedUp = tree |> propagateUp
    return propagateDown(tree, propagatedUp, inherited: nil)
}

/// - returns: Relative duration value scaled by the given `distance`.
func decodeDuration(_ original: Int, _ distance: Int) -> Int {
    return original * Int(pow(2, Double(distance)))
}

/// - returns: Distance (in powers-of-two) from one relative durational value to another.
func encodeDistance(_ original: Int, _ new: Int) -> Int {
    return Int(log2(Double(new) / Double(original)))
}

/// - TODO: Move to `Collections` or other framework
infix operator |> : AdditionPrecedence

/// Pipe
internal func |> <A, Z> (lhs: A, rhs: (A) -> Z) -> Z {
    return rhs(lhs)
}

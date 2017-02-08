//
//  RelativeDurationTree.swift
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
public typealias RelativeDuration = Int

/// Representation of the power-of-two quotient between two `RelativeDuration` values.
public typealias Distance = Int

/// Representation of relative durations.
public typealias RelativeDurationTree = Tree<RelativeDuration>

/// Representation of encoded distances between relative durational values.
public typealias DistanceTree = Tree<Distance>

/// - returns: A new `RelativeDurationTree` in which the value of each node can be represented
/// with the same subdivision-level (denominator).
public func normalized(_ tree: RelativeDurationTree) -> RelativeDurationTree {

    // Reduce each level of children by their `gcd`
    let siblingsReduced = tree |> reducingSiblings
    
    // Match parent values to the closest power-of-two to the sum of their children values.
    let parentsMatched = siblingsReduced |> matchingParentsToChildren

    // Generate a tree which contains the values necessary to multiply each node of a
    // `reduced` tree to properly match the values in a `parentsMatched` tree.
    let distanceTree = zip(siblingsReduced, parentsMatched, encodeDistance) |> propagated

    /// Multiply each value in `siblingsReduced` by the corrosponding multiplier in the 
    /// `distanceTree`.
    return zip(siblingsReduced, distanceTree, decodeDuration)
}

/// - returns: A new `RelativeDurationTree` for which each level of sub-trees is at its most
/// reduced level (e.g., `[2,4,6] -> [1,2,3]`).
internal func reducingSiblings(_ tree: RelativeDurationTree) -> RelativeDurationTree {
    
    func traverse(_ tree: RelativeDurationTree) -> RelativeDurationTree {
        
        guard case .branch(let value, let trees) = tree, !trees.isEmpty else {
            return tree
        }
        
        let values = trees.map { $0.value }
        let gcd = values.gcd!
        let reduced = values.map { $0 / gcd }
        
        let newTrees = zip(trees, reduced).map { tree, newValue in
            tree.updating(value: newValue)
        }
        
        return .branch(value, newTrees.map(traverse))
    }
    
    return traverse(tree)
}

/// - returns: Relative duration value scaled by the given `distance`.
func decodeDuration(_ original: Int, _ distance: Int) -> Int {
    return original * Int(pow(2, Double(distance)))
}

/// - returns: Distance (in powers-of-two) from one relative durational value to another.
func encodeDistance(_ original: Int, _ new: Int) -> Int {
    return Int(log2(Double(new) / Double(original)))
}

/// - returns: `RelativeDurationTree` with the values of parents matched to the closest
/// power-of-two of the sum of the values of their children.
///
/// There are two cases where action is required:
///
/// - Parent is scaled _up_ to match the sum of its children
/// - Parent is scaled _down_ to match the sum of its children
internal func matchingParentsToChildren(_ tree: RelativeDurationTree)
    -> RelativeDurationTree
{
    
    func traverse(_ tree: RelativeDurationTree) -> RelativeDurationTree {
        
        guard case .branch(let duration, let trees) = tree else {
            return tree
        }

        let relativeDurations = trees.map { $0.value }
        let sum = relativeDurations.sum
        
        var newDuration: Int {
            switch compare(duration, sum) {
            case .equal:
                return duration
            case .lessThan:
                return closestPowerOfTwo(withCoefficient: duration, to: sum)!
            case .greaterThan:
                return duration / gcd(duration, sum)
            }
        }
        
        return .branch(newDuration, trees.map(traverse))
    }
    
    return traverse(tree)
}

/// - TODO: move to `Collections`
func zip <T,U,V> (_ a: Tree<T>, _ b: Tree<U>, _ f: (T, U) -> V) -> Tree<V> {
    
    switch (a,b) {
    case (.leaf(let a), .leaf(let b)):
        return .leaf(f(a,b))
    case (.branch(let a, let aTrees), .branch(let b, let bTrees)):
        return .branch(f(a,b), zip(aTrees, bTrees).map { a,b in zip(a,b,f) })
    default:
        fatalError("Incompatible trees")
    }
}

/// - returns: `DistanceTree` with distances propagated up and down.
internal func propagated(_ tree: DistanceTree) -> DistanceTree {

    /// Propagate up and accumulate the maximum of the sums of children values
    func propagateUp(_ tree: DistanceTree) -> DistanceTree {
        
        switch tree {
            
        case .leaf:
            return tree
        
        case .branch(let value, let trees):
            
            let newTrees = trees.map(propagateUp)
            let max = newTrees.map { $0.value }.max()!
            
            return .branch(value + max, newTrees)
        }
    }
    
    /// Takes in the original distance tree, the distance tree which has already
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

/// - TODO: Move to `Collections` or other framework
infix operator |> : AdditionPrecedence

/// Pipe
internal func |> <A, Z> (lhs: A, rhs: (A) -> Z) -> Z {
    return rhs(lhs)
}

//
//  RelativeDurationTree.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import Foundation
import Collections
import ArithmeticTools

/// Representation of relative durations
public typealias RelativeDurationTree = Tree<Int>
public typealias DistanceTree = Tree<Int>

/// - returns: A new `RelativeDurationTree` in which the value of each node can be represented
/// with the same subdivision-level (denominator).
public func normalized(_ tree: RelativeDurationTree) -> RelativeDurationTree {

    // Reduce each level of children by their `gcd`
    let siblingsReduced = tree |> reduced
    
    // Match parent values to the closest power-of-two to the sum of their children values.
    let parentsMatched = siblingsReduced |> matchingParentsToChildren

    // Generate a tree which contains the values necessary to multiply each node of a
    // `reduced` tree to properly match the values in a `parentsMatched` tree.
    let distanceTree = distances(
        betweenSiblingReduced: siblingsReduced,
        andParentMatching: parentsMatched
    )

    /// Apply the given
    return zip(distanceTree, siblingsReduced) { distance, original in
        return original * Int(pow(2, Double(distance)))
    }
}


/// - returns: A new `RelativeDurationTree` for which each level of sub-trees is at its most
/// reduced level (e.g., `[2,4,6] -> [1,2,3]`).
internal func reduced(_ tree: RelativeDurationTree) -> RelativeDurationTree {
    
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
        
        switch tree {
            
        // Our work is done
        case .leaf:
            return tree
        
        // Either:
        //
        // - Parent is scaled _up_ to match the sum of its children, or
        // - Parent is scaled _down_ to match the sum of its children
        //
        // Then, visit children
        case .branch(let duration, let trees):
            
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

/// - returns: `RelativeDuration` updated with the distances in the given `distanceTree`.
internal func apply(_ distances: DistanceTree, to durations: RelativeDurationTree)
    -> RelativeDurationTree
{
 
    func traverse(_ durations: RelativeDurationTree, _ distances: DistanceTree)
        -> RelativeDurationTree
    {
        
        func multiplier(_ distance: Int) -> Int {
            return Int(pow(2, Double(distance)))
        }
        
        switch (durations, distances) {
            
        case (.leaf(let duration), .leaf(let distance)):
            return .leaf(duration * multiplier(distance))
            
        case (.branch(let duration, let durTrees), .branch(let distance, let distTrees)):
            
            return .branch(
                duration * multiplier(distance),
                zip(durTrees, distTrees).map(traverse)
            )
            
        default:
            fatalError("Incompatible trees")
        }
    }
    
    return traverse(durations, distances)
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


/// use zip :o !
/// - returns: Tree containing values for power-of-two degree of distance of `parentsMatched`
/// from original.
internal func distances(
    betweenSiblingReduced old: RelativeDurationTree,
    andParentMatching new: RelativeDurationTree
) -> DistanceTree
{

    func traverse(_ old: RelativeDurationTree, _ new: RelativeDurationTree) -> DistanceTree {
        
        func distance(_ old: Int, _ new: Int) -> Int {
            return Int(log2(Double(new) / Double(old)))
        }
        
        switch (old, new) {
            
        // In the case of a `leaves`, calculate the distance
        case (.leaf(let old), .leaf(let new)):
            return .leaf(distance(old, new))
            
        // In the case of `branches`, calculate the distance, then recurseu
        case (.branch(let oldVal, let oldTrees), .branch(let newVal, let newTrees)):
        
            guard oldTrees.count == newTrees.count else {
                fatalError("Incompatible trees")
            }
            
            return .branch(distance(oldVal, newVal), zip(oldTrees, newTrees).map(traverse))
            
        // Enforce same-shaped trees
        default:
            fatalError("Incompatible trees")
        }
    }

    return traverse(old, new) |> propagated
}

/// - TODO: Move to `Collections` or other framework
infix operator |> : AdditionPrecedence

/// Pipe
internal func |> <A, Z> (lhs: A, rhs: (A) -> Z) -> Z {
    return rhs(lhs)
}

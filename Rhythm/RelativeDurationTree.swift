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

/// - returns: A new `RelativeDurationTree` in which the value of each node can be represented
/// with the same subdivision-level (denominator).
public func normalized(_ tree: RelativeDurationTree) -> RelativeDurationTree {

    // Reduce each level of children by their `gcd`
    let reducedTree = tree |> reduced
    
    print("reduced:\n\(reducedTree)\n")
    
    // Matches parent values to the closest power-of-two to the sum of their children values.
    let parentsMatched = reducedTree |> matchingParentsToChildren
    
    print("reduced:\n\(parentsMatched)\n")
    
    // Tree containing values for power-of-two degree of distance of `parentsMatched` from 
    // original.
    let distances = distanceTree(original: tree, new: parentsMatched)

    // Apply the tree of distances to the `reducedTree`
    let updatedTree = apply(distanceTree: distances, to: reducedTree)

    // Ensure that leaves are lifted to match parents that have been lifted due to activity
    // in sibling branches
    let leavesMatched = updatedTree |> liftLeavesToMatchParent
    
    // gtfo
    return leavesMatched
}

/// - returns: A new `RelativeDurationTree` in which there are all `leaf` values are brought
/// up to match any parent nodes which have been altered.
internal func liftLeavesToMatchParent(_ tree: RelativeDurationTree) -> RelativeDurationTree {

    func traverse(_ tree: RelativeDurationTree) -> RelativeDurationTree {
        
        switch tree {
            
        // In the case of a `leaf`, our work is done
        case .leaf:
            return tree
            
        // Recurse if not a container of only leaves, otherwise, adjust subtree values
        case .branch(let value, let trees):

            // Only do work if this `tree` is a container of only `leaf` values. Otherwise,
            // recurse.
            guard tree.height == 1 else {
                return .branch(value, trees.map(traverse))
            }
                
            let sum = trees.map { $0.value }.sum
            
            // If `sum` is `>=` `value`, our work is done
            guard value > sum else {
                return tree
            }
            
            let newSum = closestPowerOfTwo(withCoefficient: sum, to: value)!
            let quotient = newSum / sum
            let newLeaves = trees.map { $0.updating(value: $0.value * quotient) }
            return .branch(value, newLeaves)
        }
    }
    
    return traverse(tree)
}

/// - returns: `RelativeDuration` updated with the distances in the given `distanceTree`.
internal func apply(distanceTree: RelativeDurationTree, to tree: RelativeDurationTree)
    -> RelativeDurationTree
{

    func traverse(_ tree: RelativeDurationTree, _ distances: [Int]) -> RelativeDurationTree {
        
        guard let (distance, remaining) = distances.destructured else {
            fatalError("Ill-formed distances")
        }
        
        let power = Int(pow(2, Double(distance)))
        
        switch tree {
        case .leaf(let value):
            return tree.updating(value: value * power)
        case .branch(let value, let trees):
            return .branch(value * power, trees.map { traverse($0, remaining) })
        }
    }

    return traverse(tree, distanceTree |> distanceByLevel)
}

/// Records the distance required by each level. Propagates the changes up from the leaves to
/// the root.
internal func distanceByLevel(_ distanceTree: RelativeDurationTree) -> [Int] {
    return merge(distanceTree.paths, compare: >) |> propagate
}

/// Accumulates distance up the tree.
///
/// - TODO: do this in foldr fashion rather than reduce, with `reversed()`
internal func propagate(_ array: [Int]) -> [Int] {
    
    return array
        .lazy
        .reversed()
        .reduce([]) { accum, cur in accum + (cur + (accum.last ?? 0)) }
        .reversed()
}

/// - returns: Tree containing values for power-of-two degree of distance of `parentsMatched`
/// from original.
///
/// - TODO: Also apply to leaves
internal func distanceTree(
    original: RelativeDurationTree,
    new: RelativeDurationTree
) -> RelativeDurationTree
{

    func traverse(
        _ original: RelativeDurationTree,
        _ matched: RelativeDurationTree
    ) -> RelativeDurationTree
    {
        
        func distance(_ a: Int, _ b: Int) -> Int {
            return Int(log2(Double(b) / Double(a)))
        }
        
        switch (original, matched) {
            
        // In the case of a `leaves`, calculate the distance
        case (.leaf(let original), .leaf(let matched)):
            return .leaf(distance(original, matched))
            
        // In the case of `branches`, calculate the distance, then recurseu
        case (.branch(let val0, let trees0), .branch(let val1, let trees1)):
        
            guard trees0.count == trees1.count else {
                fatalError("Incompatible trees")
            }
            
            return .branch(distance(val0, val1), zip(trees0, trees1).map(traverse))
            
        // Enforce same-shaped trees
        default:
            fatalError("Incompatible trees")
        }
    }
    
    return traverse(original, new)
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
            
        case .leaf:
            return tree
            
        case .branch(let duration, let trees):
            
            let relativeDurations = trees.map { $0.value }
            let sum = relativeDurations.sum
            
            switch compare(duration, sum) {
            case .equal:
                return .branch(duration, trees.map(traverse))
            case .lessThan:
                let newDuration = closestPowerOfTwo(withCoefficient: duration, to: sum)!
                return .branch(newDuration, trees.map(traverse))
            case .greaterThan:
                let newDuration = duration / gcd(duration, sum)
                return .branch(newDuration, trees.map(traverse))
            }
        }
    }

    return traverse(tree)
}

/// - returns: A new `RelativeDurationTree` in which each level of sub-trees is at its most
/// reduced level (`[2,4,6] -> [1,2,3]`).
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


func merge <T> (_ arrays: [[T]], compare: @escaping (T, T) -> Bool) -> [T] {
    
    guard
        let startIndex = arrays.map({ $0.startIndex }).min(),
        let endIndex = arrays.map({ $0.endIndex }).max()
    else {
        return []
    }
    
    return (startIndex ..< endIndex).map { index in
        arrays.flatMap { $0[safe: index] }.sorted(by: compare).first!
    }
}

/// - returns: Array containing the maximum value for each index of the given `arrays`.
///
/// - TODO: throw in higher-order function, generalize
/// - TODO: Change to: zip(compare: (T, T) -> Bool)
internal func maxByIndex <T: Comparable> (_ arrays: [[T]]) -> [T] {
    return merge(arrays, compare: >)
}

/// - TODO: Move to `Collections` or other framework
infix operator |> : AdditionPrecedence

/// Pipe
internal func |> <A, Z> (lhs: A, rhs: (A) -> Z) -> Z {
    return rhs(lhs)
}

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
    
    // Matches parent values to the closest power-of-two to the sum of their children values.
    let parentsMatched = reducedTree |> liftParentsToMatchChildren
    
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

    return traverse(tree, distanceTree |> distanceByLevel |> propagate)
}

/// Records the distance required by each level.
///
/// - TODO: Generalize this with a higher-order function
internal func distanceByLevel(_ distanceTree: RelativeDurationTree) -> [Int] {
    
    func traverse(_ tree: RelativeDurationTree, accum: [Int]) -> [Int] {
        
        switch tree {
        case .leaf(let value):
            return accum + value
        case .branch(let value, let trees):
            return maxByIndex(trees.map { traverse($0, accum: accum + value) })
        }
    }
    
    return traverse(distanceTree, accum: [])
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
        guard
            case .branch(let originalValue, let originalTrees) = original,
            case .branch(let matchedValue, let matchedTrees) = matched
        else {
            return .leaf(0)
        }

        guard matchedTrees.count == originalTrees.count else {
            fatalError("Incompatible trees")
        }
        
        // Possible to do with bit-shifting?
        let distance = Double(matchedValue) / Double(originalValue)
        
        print("distance: \(distance)")
        
        let unrolled = Int(log2(distance))
        
        print("unrolled: \(unrolled)")
        
        let logln = Int(log(distance))
        
        print("logln: \(logln)")
        
        return .branch(unrolled, zip(originalTrees, matchedTrees).map(traverse))
    }
    
    return traverse(original, new)
}

/// - returns: `RelativeDurationTree` with the values of parents lifted to the closest 
/// power-of-two of the sum of the values of their children.
internal func liftParentsToMatchChildren(_ tree: RelativeDurationTree)
    -> RelativeDurationTree
{
    
    func traverse(_ tree: RelativeDurationTree) -> RelativeDurationTree {
        
        switch tree {
            
        case .leaf:
            
            return tree
            
        case .branch(let duration, let trees):
            
            let relativeDurations = trees.map { $0.value }
            let sum = relativeDurations.sum
            let newDuration = closestPowerOfTwo(withCoefficient: duration, to: sum)!
            return .branch(newDuration, trees.map(traverse))
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

/// - returns: Array containing the maximum value for each index of the given `arrays`.
///
/// - TODO: throw in higher-order function, generalize
internal func maxByIndex <T: Comparable> (_ arrays: [[T]]) -> [T] {
    
    guard
        let startIndex = arrays.map({ $0.startIndex }).min(),
        let endIndex = arrays.map({ $0.endIndex }).max()
    else {
        fatalError("You gave me an empty array!")
    }
    
    return (startIndex..<endIndex).map { index in
        return arrays.flatMap { array in array[safe: index] }.max()!
    }
}

/// - TODO: Move to `Collections` or other framework
infix operator |> : AdditionPrecedence

/// Pipe
internal func |> <A, Z> (lhs: A, rhs: (A) -> Z) -> Z {
    return rhs(lhs)
}

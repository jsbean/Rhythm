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

public func normalized(_ tree: RelativeDurationTree) -> RelativeDurationTree {
    let ds = distances(between: tree, and: matchLevels(tree)) |> distanceByLevel |> propagate
    return apply(ds, to: tree) |> matchLeaves
}

/// - TODO: doc comment / make private
public func matchLeaves(_ tree: RelativeDurationTree) -> RelativeDurationTree {

    func traverse(_ tree: RelativeDurationTree) -> RelativeDurationTree {
        
        switch tree {
        case .leaf:
            return tree
            
        case .branch(let value, let trees):

            guard tree.height == 1 else {
                return .branch(value, trees.map(traverse))
            }
                
            let sum = trees.map { $0.value }.sum
            
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

/// - TODO: Remove duplication
public func apply(_ distances: [Int], to tree: RelativeDurationTree) -> RelativeDurationTree {

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
    
    return traverse(reduced(tree), distances)
}

// TODO: do this in foldr fashion rather than reduce, with `reversed()`
public func propagate(_ array: [Int]) -> [Int] {
    
    return array
        .lazy
        .reversed()
        .reduce([]) { accum, cur in accum + (cur + (accum.last ?? 0)) }
        .reversed()
}

/// Generalize this with a higher-order function
public func distanceByLevel(_ distanceTree: RelativeDurationTree) -> [Int] {
    
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

/// - TODO: throw in higher-order function, generalize
public func maxByIndex <T: Comparable> (_ arrays: [[T]]) -> [T] {

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

/// - TODO: doc comment, make private
public func distances(
    between original: RelativeDurationTree,
    and matched: RelativeDurationTree
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
        let unrolled = Int(log(distance)) + 1
        
        return .branch(unrolled, zip(originalTrees, matchedTrees).map(traverse))
    }
    
    return traverse(original, matched)
}

public func matchLevels(_ tree: RelativeDurationTree) -> RelativeDurationTree {
    
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

    return tree |> reduced |> traverse
}

/// - TODO: Move to other framework ?
infix operator |> : AdditionPrecedence

public func |> <A, Z> (lhs: A, rhs: (A) -> Z) -> Z {
    return rhs(lhs)
}

/// - returns: A new `RelativeDurationTree` in which each level of sub-trees is at its most
/// reduced level (`[2,4,6] -> [1,2,3]`).
public func reduced(_ tree: RelativeDurationTree) -> RelativeDurationTree {
    
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

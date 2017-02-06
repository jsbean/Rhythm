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

/// - TODO: doc comment
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
            return .leaf(-1)
        }

        guard matchedTrees.count == originalTrees.count else {
            fatalError("Incompatible trees")
        }
        
        let distance = Double(matchedValue) / Double(originalValue)
        let unrolled = Int(log(distance))
        
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

public func |> <A,Z> (lhs: A, rhs: (A) -> Z) -> Z {
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

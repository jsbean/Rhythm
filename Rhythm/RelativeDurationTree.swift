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

/// Normalized version of `RelativeDurationTree` where all values can be represented with the
/// same subdivision level.
///
/// - TODO: Make instance method of `RelativeDurationTree` when this is possibe in Swift.
public func normalized(_ tree: RelativeDurationTree) -> RelativeDurationTree {

    // normalize parent to children
    // propogate up: if change, keep propagating
    func traverse(_ zippedTree: Zipper<Int>) -> Zipper<Int> {
        
        guard case .branch(let duration, let trees) = zippedTree.tree else {
            return zippedTree
        }
        
//        // Relative durations of subtrees
//        let relativeDurations = trees.map { $0.value }
//        
//        /// The sum of relative durations
//        let sum = relativeDurations.sum
//        
//        let newBranch: RelativeDurationTree
//        switch compare(duration, sum) {
//        case .equal:
//            newBranch = zippedTree.tree
//        case .lessThan:
//            newBranch = zippedTree.tree
//        case .greaterThan:
//            newBranch = zippedTree.tree
//        }
        
//        // Handle different relationships between parent duration and children durations
//        switch compare(duration, sum) {
//            
//        // If the sum of the children is equal to the parent duration, our work is done
//        case .equal:
//            return branch
//            
//        // Scale the parent up to get close to the sum of the children
//        case .lessThan:
//            let newDuration = closestPowerOfTwo(withCoefficient: duration, to: sum)!
//            return .branch(newDuration, trees)
//            
//        // Scale the durations of the children up to get close to the parent duration
//        case .greaterThan:
//            let newSum = closestPowerOfTwo(withCoefficient: sum, to: duration)!
//            let quotient = newSum / trees.count
//            return .branch(duration, trees.map { map($0) { quotient * $0 } })
//        }
//
//        
        // do operation
        
        // propagate up
        

        
        for t in trees.indices {
            let updated = zippedTree.update(value: 2)
            //let subZipper = zippedTree.move(to: t).update(<#T##f: (Int) -> Int##(Int) -> Int#>)
        }
        
        return zippedTree
    }

    
    let zipper = Zipper(tree)
    return traverse(zipper).tree
}

/*
/// Normalizes a `RelativeDurationTree` such that all values can be represented with the same
/// subdivision values.
public func normalized(_ tree: RelativeDurationTree) -> RelativeDurationTree {
    
    // Match the durations of the parent and children as appropriate
    func locallyNormalize(_ branch: RelativeDurationTree) -> RelativeDurationTree {
        
        guard case .branch(let duration, let trees) = branch else {
            fatalError("Branch operation called on a leaf")
        }
    
        // Relative durations of subtrees
        let relativeDurations = trees.map { $0.value }
        
        /// The sum of relative durations
        let sum = relativeDurations.sum
    
        // Handle different relationships between parent duration and children durations
        switch compare(duration, sum) {
            
        // If the sum of the children is equal to the parent duration, our work is done
        case .equal:
            return branch
        
        // Scale the parent up to get close to the sum of the children
        case .lessThan:
            let newDuration = closestPowerOfTwo(withCoefficient: duration, to: sum)!
            return .branch(newDuration, trees)
        
        // Scale the durations of the children up to get close to the parent duration
        case .greaterThan:
            let newSum = closestPowerOfTwo(withCoefficient: sum, to: duration)!
            let quotient = newSum / trees.count
            return .branch(duration, trees.map { map($0) { quotient * $0 } })
        }
    }
    
    func traverse(_ branch: RelativeDurationTree) -> RelativeDurationTree {

        // Blow up if programmer error got us here
        guard case .branch(_, let trees) = branch else {
            fatalError("Branch operation called on a leaf")
        }
        
        // Match the durations of the parent and children as appropriate
        var normalizedBranch = locallyNormalize(branch)
        
        //trees.enumerated().filter { (i, subTree) in false }
        
        // Iterate over children, recursing into branches
        for (t, subTree) in trees.enumerated() {
            
            guard case .branch = subTree else { continue }

            // Update values in subtree
            let traversedSubTree = traverse(subTree)
            
            //
            normalizedBranch = update(
                duration: traversedSubTree.value,
                forTreeAt: t,
                of: normalizedBranch
            )
        }
        
        return normalizedBranch
    }
    
    return traverse(tree)
}

private func update(duration: Int, forTreeAt index: Int, of branch: RelativeDurationTree)
    -> RelativeDurationTree
{
    
    guard case .branch(_, let trees) = branch else {
        fatalError("Branch operation called on a leaf")
    }
    
    let quotient = duration / trees[index].value
    
    // Only scale the branch if there is a change in value
    return quotient != 1 ? scale(branch, by: quotient) : branch
}

/// - Updates the value of the tree at the given `index`
/// - Compares its value to the previous value
/// - Updates its siblings by the same Δ
/// - Updates the parent by the same Δ
private func injectTree(
    at index: Int,
    with tree: RelativeDurationTree,
    of branch: RelativeDurationTree
) -> RelativeDurationTree
{
    
    guard case .branch(_, let trees) = branch else {
        fatalError("Branch operation called on a leaf")
    }
    
    return scale(branch, by: tree.value / trees[index].value)
}

private func scale(_ tree: RelativeDurationTree, by factor: Int) -> RelativeDurationTree {
    switch tree {
    case .leaf(let duration):
        return .leaf(duration * factor)
    case .branch(let duration, let trees):
        return .branch(duration * factor, trees.map { map($0) { $0 * factor } })
    }
}

private func map (_ tree: RelativeDurationTree, _ f: (Int) -> Int) -> RelativeDurationTree {
    return tree.updating(value: f(tree.value))
}
*/

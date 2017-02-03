//
//  RelativeDurationTree.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import Collections
import ArithmeticTools

/// Representation of relative durations
public typealias RelativeDurationTree = Tree<Int>

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
        
        // Iterate over children, recursing into branches
        for (t, subTree) in trees.enumerated() {
            
            guard case .branch(let duration, _) = subTree else {
                continue
            }

            // Update values in subtree
            let traversedSubTree = traverse(subTree)
            
            // If there is a change in values, update all siblings
            if traversedSubTree.value != duration {
                
                normalizedBranch = injectTree(
                    at: t,
                    with: traversedSubTree,
                    of: normalizedBranch
                )
            }
        }
        
        return normalizedBranch
    }
    
    return traverse(tree)
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

//
//  RelativeDurationTree.swift
//  Rhythm
//
//  Created by James Bean on 2/2/17.
//
//

import Collections
import ArithmeticTools

public typealias RelativeDurationTree = Tree<Int>


//func _normalize(_ tree: RelativeDurationTree) -> RelativeDurationTree {
//    
//    
//}


func scale(_ tree: RelativeDurationTree, factor: Int) -> RelativeDurationTree {
    switch tree {
    case .leaf(let duration):
        return .leaf(duration * factor)
    case .branch(let duration, let trees):
        return .branch(duration * factor, trees.map { scale($0, factor: factor) })
    }
}


public func normalized(_ tree: RelativeDurationTree) throws -> RelativeDurationTree {
    
    func traverse(_ tree: RelativeDurationTree, path: [Int]) throws -> RelativeDurationTree {

        switch tree {
            
        // This should never be called on a `leaf`.
        case .leaf:
            fatalError()
            
        case .branch(let duration, let trees):
            
            var normalizedBranch = try normalize(branch: tree)
            for (t, subTree) in trees.enumerated() {
                
                print("t: \(t); subTree: \(subTree)")

                switch subTree {
                case .leaf:
                    break
                case .branch:
                    
                    let newNormalizedBranch = try replacingTree(
                        at: t,
                        with: traverse(subTree, path: path + [t]),
                        of: normalizedBranch
                    )
                    
                    print("new normalized branch: \(newNormalizedBranch)")
                    normalizedBranch = newNormalizedBranch
                }
            }
            
            //return try! normalize(branch: tree)
            return normalizedBranch
        }
    }
    
    return try traverse(tree, path: [])
}

public func normalize(branch: RelativeDurationTree) throws -> RelativeDurationTree {
    
    switch branch {
        
    // This should never be called on a `leaf`
    case .leaf:
        throw TreeError.branchOperationPerformedOnLeaf
    
    
    case .branch(let duration, let trees):
        let relativeDurations = trees.map { $0.value }
        let sum = relativeDurations.sum
        
        switch compare(duration, sum) {
        case .equal:
            return branch
            
        case .lessThan:
            let newDuration = closestPowerOfTwo(withCoefficient: duration, to: sum)!
            return .branch(newDuration, trees)
            
        case .greaterThan:
            let newSum = closestPowerOfTwo(withCoefficient: sum, to: duration)!
            let quotient = newSum / trees.count
            return .branch(duration, trees.map { map($0) { quotient * $0 } })
        }
    }
}

public func replacingTree(
    at index: Int,
    with tree: RelativeDurationTree,
    of branch: RelativeDurationTree
) throws -> RelativeDurationTree
{
    switch branch {
        
    case .leaf:
        throw TreeError.branchOperationPerformedOnLeaf
        
    case .branch(let duration, let trees):
        
        guard let oldTree = trees[safe: index] else {
            throw TreeError.indexOutOfBounds
        }
        
        let quotient = tree.value / oldTree.value
        
        print("quotient: \(quotient)")
        let trees = trees.map { map($0) { $0 * quotient } }
        let newDuration = duration * quotient
        return .branch(newDuration, trees)
    }
}

public func updating(value: Int, ofTreeAt index: Int, of branch: RelativeDurationTree) throws
    -> RelativeDurationTree
{
    switch branch {
        
    case .leaf:
        throw TreeError.branchOperationPerformedOnLeaf
        
    case .branch(let duration, let trees):
        
        guard let oldTree = trees[safe: index] else {
            throw TreeError.indexOutOfBounds
        }
        
        let quotient = value / oldTree.value
        //let newDuration = value >= oldTree.value ? duration * quotient : duration
        return .branch(duration, trees.map { map($0) { $0 * quotient } })
    }
}

/// Make generic
public func map (_ tree: RelativeDurationTree, _ f: (Int) -> Int) -> RelativeDurationTree {
    return tree.updating(value: f(tree.value))
}

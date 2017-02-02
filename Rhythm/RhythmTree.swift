//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

/// Tree structure representing rhythm, parameratized over `T`.
///
/// Each `branch` case carries with it a `MetricalDuration` payload, while each `leaf` case
/// carries with it a `MetricalLeaf<T>` payload (the product of a `MetricalDuration` and a 
/// `MetricalContext`).
//public typealias RhythmTree <T> = Tree<MetricalDuration, MetricalLeaf<T>>

public enum RhythmTree {
    
    /// - TODO: make rich
    public enum Error: Swift.Error {
        case indexOutOfBounds
    }
    
    // MetricalBranch = (MetricalDuration, [RhythmTree]) ?
    indirect case branch(MetricalDuration, [RhythmTree])
    
    case leaf(MetricalDuration, MetricalContext<Int>)
    
    //case leaf(MetricalLeaf<Int>)
    
    public var normalized: RhythmTree {
        fatalError("Not yet implemented!")
    }
    
    public var metricalDuration: MetricalDuration {
        switch self {
        case .leaf(let duration, _):
            return duration
        case .branch(let duration, _):
            return duration
        }
    }
    
    public init(_ metricalDuration: MetricalDuration, _ trees: [RhythmTree] = []) {
        self = .branch(metricalDuration, trees)
    }
    
    public init(_ metricalDuration: MetricalDuration, _ relativeDurations: [Int]) {

        guard !relativeDurations.isEmpty else {
            fatalError("Have to provide relative durations")
        }
        
        // 2 possibilities:
        // (5/16): [1,1] (sum below numerator)
        // (5,16): [1,2,3,4,5,6,7] (sum above numerator)
        
        // set MetricalDuration (and therefore denominator)
        // normalize relative durations
        
        var metricalDuration = metricalDuration.reduced
        print("metrical duration: \(metricalDuration)")
        
        let reducedDurations = relativeDurations.map { $0 / relativeDurations.gcd! }

        let sum = reducedDurations.sum
        let numerator = metricalDuration.numerator
        
        let newNumerator = closestPowerOfTwo(withCoefficient: numerator, to: sum)!
        metricalDuration = metricalDuration.respelling(numerator: newNumerator)!
        
        let leaves = reducedDurations
            .lazy
            .map { MetricalDuration($0, metricalDuration.denominator) }
            .map { RhythmTree.leaf($0, MetricalContext.instance(.event(1))) }
        
        self = RhythmTree.branch(metricalDuration, Array(leaves))
    }
    
    public func with(metricalDuration: MetricalDuration) -> RhythmTree {
        switch self {
        case .leaf(_, let context):
            return .leaf(metricalDuration, context)
        case .branch(_, let trees):
            // update trees metrical duration
            return .branch(metricalDuration, trees)
        }
    }
    
    public var leaves: [(MetricalDuration, MetricalContext<Int>)] {
        
        func flattened(
            accum: [(MetricalDuration, MetricalContext<Int>)],
            tree: RhythmTree
        ) -> [(MetricalDuration, MetricalContext<Int>)]
        {
            switch tree {
            case .branch(_, let trees):
                return trees.reduce(accum, flattened)
            case .leaf(let duration, let context):
                return accum + [(duration, context)]
            }
        }
        
        return flattened(accum: [], tree: self)
    }
    
    public func inserting(tree: RhythmTree, at index: Int) throws -> RhythmTree {

        switch self {
        case .leaf(let duration, _):
            return .branch(duration, [tree])
        case .branch(let metricalDuration, let trees):
            
            guard let (left, right) = trees.split(at: index) else {
                throw Error.indexOutOfBounds
            }

            return .branch(metricalDuration, left + tree + right)
        }
    }
//
//    // make try?
//    public func replacing(tree: RhythmTree, forTreeAt index: Int) throws -> RhythmTree {
//        fatalError("Not yet implemented!")
//    }
//    
//    public func inserting(tree: RhythmTree, indexPath: [Int]) throws -> RhythmTree {
//        
//        // traverse to get new container branch
//        func traverse(tree: RhythmTree, indexPath: [Int]) -> RhythmTree? {
//            
//            guard let (head, tail) = indexPath.destructured else {
//                return nil
//            }
//            
//            switch tree {
//            case .leaf(let value):
//                return nil
//            case .branch(let duration, let trees):
//                
//                
//                if indexPath.count > 1 {
//                    traverse(tree: tree, indexPath: tail)
//                }
//                
//                break
//            }
//
//
//            
//            fatalError("Not yet implemented")
//        }
//        
//        guard indexPath.count > 0 else {
//            fatalError("Must provide at least index in index path")
//        }
//        
//        guard let container = traverse(tree: self, indexPath: indexPath) else {
//            throw Error.indexOutOfBounds
//        }
//        
//        fatalError("Not yet implemented!")
//    }
//    
//    // [RhythmTree]?
//    private func path(indexPath: [Int]) throws -> [RhythmTree] {
//        
//        func traverse(_ tree: RhythmTree, result: [RhythmTree], indexPath: [Int])
//            throws -> [RhythmTree]
//        {
//            
//            print("traverse: \(tree); result: \(result); indexPath: \(indexPath)")
//            
//            guard let (head, tail) = indexPath.destructured else {
//                return result + [tree]
//            }
//            
//            switch tree {
//            case .leaf:
//                throw Error.indexOutOfBounds
//            case .branch(_, let trees):
//                
//                guard trees.indices.contains(head) else {
//                    throw Error.indexOutOfBounds
//                }
//                
//                return try traverse(trees[head], result: result + [tree], indexPath: tail)
//            }
//        }
//        
//        return try traverse(self, result: [], indexPath: indexPath)
//    }
}

extension RhythmTree: CustomStringConvertible {
    
    /// Printed description.
    public var description: String {
        
        func indents(_ amount: Int, value: String = "  ") -> String {
            return (0 ..< amount).reduce("") { accum, _ in accum + value }
        }
        
        func traverse(tree: RhythmTree, indentation: Int = 0) -> String {
            
            switch tree {
            case .leaf(let value):
                return indents(indentation) + "\(value)"
            case .branch(let value, let trees):
                return (
                    indents(indentation) + "\(value)\n" +
                        trees
                            .map { traverse(tree: $0, indentation: indentation + 1) }
                            .joined(separator: "\n")
                )
            }
        }
        
        return traverse(tree: self)
    }
}

// TODO: Move down to `Collections`, abstract to a `Sequence` extension
extension Array {
    
    public func split(at index: Index) -> ([Element], [Element])? {
        
        guard index >= startIndex && index <= endIndex else {
            return nil
        }
        
        let left = Array(self[startIndex ..< index])
        let right = index == endIndex ? [] : Array(self[index ..< endIndex])
        
        return (left, right)
    }
}

/// - TODO: Refine
public func << (metricalDuration: MetricalDuration, relativeDurations: [Int]) -> RhythmTree {
    return RhythmTree(metricalDuration, relativeDurations)
}

//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections

/// Tree structure representing rhythm, parameratized over `T`.
///
/// Each `branch` case carries with it a `MetricalDuration` payload, while each `leaf` case
/// carries with it a `MetricalLeaf<T>` payload (the product of a `MetricalDuration` and a 
/// `MetricalContext`).
//public typealias RhythmTree <T> = Tree<MetricalDuration, MetricalLeaf<T>>

public enum RhythmTree {
    
    indirect case branch(MetricalDuration, [RhythmTree])
    
    case leaf(MetricalLeaf<Int>)
    
    public init(_ metricalDuration: MetricalDuration, _ trees: [RhythmTree] = []) {
        self = .branch(metricalDuration, trees)
    }
    
    public init(_ metricalDuration: MetricalDuration, _ relativeDurations: [Int]) {

        let leaves = relativeDurations
            .lazy
            .map { MetricalDuration($0, metricalDuration.denominator) }
            .map { MetricalLeaf($0, MetricalContext.instance(.event(1))) }
            .map { RhythmTree.leaf($0) }
        
        self = RhythmTree.branch(metricalDuration, Array(leaves))
    }
    
    public var leaves: [MetricalLeaf<Int>] {
        func flattened(accum: [MetricalLeaf<Int>], tree: RhythmTree) -> [MetricalLeaf<Int>] {
            switch tree {
            case .branch(_, let trees):
                return trees.reduce(accum, flattened)
            case .leaf(let value):
                return accum + [value]
            }
        }
        
        return flattened(accum: [], tree: self)
    }
    
    public func inserting(tree: RhythmTree, at index: Int) -> RhythmTree {

        switch self {
        case .leaf(let value):
            return .branch(value.metricalDuration, [tree])
        case .branch(let metricalDuration, let trees):
            
            guard let (left, right) = trees.split(at: index) else {
                fatalError("Index out of range")
            }

            return .branch(metricalDuration, left + tree + right)
        }
    }
    
    public func replacing(tree: RhythmTree, forTreeAt index: Int) -> RhythmTree {
        fatalError("Not yet implemented!")
    }
    
    public func inserting(tree: RhythmTree, indexPath: [Int]) -> RhythmTree {
        fatalError("Not yet implemented!")
    }
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

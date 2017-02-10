//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

/// Wraps heterogeneous data types for `leaf` and `branch` cases in a `RhythmTree`.
///
/// In a `RhythmTree`, a `branch` holds only a `MetricalDuration`, while a `leaf` holds both a
/// `MetricalDuration` and a `MetricalContext<T>`.
///
/// Operations on nodes within a `RhythmTree` will have to deconstruct this type.
public enum RhythmNode <T> {
    
    /// `RhythmTree.leaf` nodes hold a `MetricalDuration` and a `MetricalContext<T>`
    case leaf(MetricalDuration, MetricalContext<T>)
    
    /// `RhythmTree.branch` nodes hold only a `MetricalDuration`.
    case branch(MetricalDuration)
    
    /// The `MetricalDuration` value of this `RhythmNode`.
    public var duration: MetricalDuration {
        switch self {
        case .leaf(let duration, _):
            return duration
        case .branch(let duration):
            return duration
        }
    }
}

/// `Tree` that extends a `MetricalDurationTree` with `MetricalContext<T>` values in the `leaf`
/// nodes.
public typealias RhythmTree = Tree<RhythmNode<Int>>

extension Tree where T == RhythmNode<Int> {
    
    /// The `MetricalDuration` value of this `RhythmTree` node.
    public var duration: MetricalDuration {
        
        switch self {
        case .leaf(let node):
            return node.duration
        case .branch(let node, _):
            return node.duration
        }
    }
    
    /// Create a `RhythmTree` with the `MetricalDuration` values of the given 
    /// `metricalDurationTree`, mapped with `event`.
    public init(_ metricalDurationTree: MetricalDurationTree) {
        
        func traverse(_ tree: MetricalDurationTree) -> RhythmTree {
            
            switch tree {
            case .leaf(let value):
                let leaf = RhythmNode.leaf(value, .instance(.event(1)))
                return .leaf(leaf)
            case .branch(let value, let trees):
                let branch = RhythmNode<Int>.branch(value)
                return .branch(branch, trees.map(traverse))
            }
        }
        
        self = traverse(metricalDurationTree)
    }
}

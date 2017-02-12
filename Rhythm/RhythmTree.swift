//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

/// `Tree` that extends a `MetricalDurationTree` with `MetricalContext<T>` values for `leaf`
/// nodes.
public struct RhythmTree <T: Equatable> {
    
    public let metricalDurationTree: MetricalDurationTree
    public let leafContexts: [MetricalContext<T>]
    
    public init(
        _ metricalDurationTree: MetricalDurationTree,
        _ leafContexts: [MetricalContext<T>]
    )
    {
        
        /// This is an expensive check (`tree.leaves` is O(n))
        guard leafContexts.count == metricalDurationTree.leaves.count else {
            fatalError("Incompatible leaf contexts for tree")
        }
        
        self.metricalDurationTree = metricalDurationTree
        self.leafContexts = leafContexts
    }
    
    // TODO: Add node with contexts
    // TODO: Insert ""
    // TODO: Remove node
}

extension RhythmTree: Equatable {
    
    public static func == <T: Equatable> (lhs: RhythmTree<T>, rhs: RhythmTree<T>) -> Bool {
        return (
            lhs.metricalDurationTree == rhs.metricalDurationTree &&
            lhs.leafContexts == rhs.leafContexts
        )
    }
}

/// - returns: `RhythmTree` with the given `MetricalDurationTree` and `MetricalContext` values.
public func * <T> (lhs: MetricalDurationTree, rhs: [MetricalContext<T>]) -> RhythmTree<T> {
    return RhythmTree(lhs, rhs)
}

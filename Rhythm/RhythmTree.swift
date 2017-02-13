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

    /// - returns: Tuple containing `MetricalDuration` and `MetricalContext` information 
    /// about the leaves of the `RhythmTree`.
    public var leaves: [(duration: MetricalDuration, context: MetricalContext<T>)] {
        return Array(zip(metricalDurationTree.leaves, leafContexts))
    }
    
    /// Creates a `RhythmTree` with the given `metricalDurationTree` and `leafContexts`.
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

extension Sequence where Iterator.Element == RhythmTree<Int> {
    
    /// - returns: Effective durations of events, merging tied durations.
    public var lengths: [MetricalDuration] {
        
        func merge(
            _ lengths: [(duration: MetricalDuration, context: MetricalContext<Int>)],
            accum: [MetricalDuration],
            tied: MetricalDuration?
        ) -> [MetricalDuration]
        {
            
            guard let (leaf, remaining) = lengths.destructured else {
                return accum + tied
            }
            
            switch leaf.context {
                
            case .continuation:
                return merge(remaining, accum: accum, tied: (tied ?? .zero) + leaf.duration)
                
            case .instance(let absenceOrEvent):
                
                switch absenceOrEvent {
                    
                case .absence:
                    return merge(remaining, accum: accum + tied + leaf.duration, tied: nil)
                case .event:
                    return merge(remaining, accum: accum + tied, tied: leaf.duration)
                }
            }
        }
        
        return merge(flatMap { $0.leaves }, accum: [], tied: nil)
    }
}


extension Array {
    
    /// - TODO: Move to `Collections`.
    public static func + (lhs: Array, rhs: Element?) -> Array {
        
        if let element = rhs {
            return lhs + element
        }
        
        return lhs
    }
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

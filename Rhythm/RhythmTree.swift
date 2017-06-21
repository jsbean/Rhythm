//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

public struct RhythmLeaf {
    let metricalDuration: MetricalDuration
    let context: MetricalContext<Int>
}

extension RhythmLeaf: Equatable {
    
    public static func == (lhs: RhythmLeaf, rhs: RhythmLeaf) -> Bool {
        return lhs.metricalDuration == rhs.metricalDuration && lhs.context == rhs.context
    }
}

public typealias RhythmTree = Tree<MetricalDuration, RhythmLeaf>

/// - Note: Use extension RhythmTree when Swift allows it
extension Tree where Branch == MetricalDuration, Leaf == RhythmLeaf {
    
    public init(
        _ metricalDurationTree: MetricalDurationTree,
        _ leafContexts: [MetricalContext<Int>]
    )
    {
        func traverse(
            _ metricalDurationTree: MetricalDurationTree,
            applying leafContexts: [MetricalContext<Int>]
        ) -> RhythmTree
        {
            switch metricalDurationTree {
            case .leaf(let metricalDuration):
                
                guard let context = leafContexts.head else {
                    fatalError("Incompatible leaf contexts for metrical duration tree")
                }
                
                return .leaf(RhythmLeaf(metricalDuration: metricalDuration, context: context))
                
            case let .branch(metricalDuration, trees):
                var leafContexts = leafContexts
                var newTrees: [RhythmTree] = []
                for tree in trees {
                    switch tree {
                    case .leaf:
                        newTrees.append(traverse(tree, applying: leafContexts))
                        leafContexts.remove(at: 0)
                    case .branch:
                        newTrees.append(traverse(tree, applying: leafContexts))
                    }
                }
                
                return .branch(metricalDuration, newTrees)
            }
        }
        
        self = traverse(metricalDurationTree, applying: leafContexts)
    }
}


/// - TODO: Implement `RhythmSequence`.
extension Sequence where Iterator.Element == RhythmTree {
    
    /// - returns: Effective durations of events, merging tied durations.
    public var lengths: [MetricalDuration] {
        
        func merge(
            _ leaves: [RhythmLeaf],
            accum: [MetricalDuration],
            tied: MetricalDuration?
        ) -> [MetricalDuration]
        {
            
            guard let (leaf, remaining) = leaves.destructured else {
                return accum + tied
            }
            
            switch leaf.context {
                
            case .continuation:
                let tied = (tied ?? .zero) + leaf.metricalDuration
                return merge(remaining, accum: accum, tied: tied)
                
            case .instance(let absenceOrEvent):
                switch absenceOrEvent {
                case .absence:
                    return merge(remaining, accum: accum + tied + leaf.metricalDuration, tied: nil)
                case .event:
                    return merge(remaining, accum: accum + tied, tied: leaf.metricalDuration)
                }
            }
        }
        
        return merge(flatMap { $0.leaves }, accum: [], tied: nil)
    }
}

/// - returns: `RhythmTree` with the given `MetricalDurationTree` and `MetricalContext` values.
public func * (lhs: MetricalDurationTree, rhs: [MetricalContext<Int>]) -> RhythmTree {
    return RhythmTree(lhs, rhs)
}

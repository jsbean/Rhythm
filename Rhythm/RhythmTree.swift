//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

public struct RhythmLeaf <T: Equatable> {
    
    public let metricalDuration: MetricalDuration
    public let context: MetricalContext<T>
    
    public init(metricalDuration: MetricalDuration, context: MetricalContext<T>) {
        self.metricalDuration = metricalDuration
        self.context = context
    }
}

public struct RhythmTree <T: Equatable> {
    
    public typealias Structure = Tree<MetricalDuration, RhythmLeaf<T>>
    
    public let tree: Structure
    
    public init(_ tree: Structure) {
        self.tree = tree
    }
}

extension RhythmLeaf: Equatable {
    
    public static func == <T: Equatable> (lhs: RhythmLeaf<T>, rhs: RhythmLeaf<T>) -> Bool {
        return lhs.metricalDuration == rhs.metricalDuration && lhs.context == rhs.context
    }
}

extension RhythmTree {
    
    public init(
        _ metricalDurationTree: MetricalDurationTree,
        _ leafContexts: [MetricalContext<T>]
    )
    {
        func traverse(
            _ metricalDurationTree: MetricalDurationTree,
            applying leafContexts: [MetricalContext<T>]
        ) -> Structure
        {
            switch metricalDurationTree {
            case .leaf(let metricalDuration):
                
                guard let context = leafContexts.head else {
                    fatalError("Incompatible leaf contexts for metrical duration tree")
                }
                
                return .leaf(RhythmLeaf(metricalDuration: metricalDuration, context: context))
                
            case let .branch(metricalDuration, trees):
                
                var leafContexts = leafContexts
                var newTrees: [Structure] = []
                
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
        
        self.init(traverse(metricalDurationTree, applying: leafContexts))
    }
}

public func lengths <S: Sequence, T: Equatable> (of rhythmTrees: S) -> [MetricalDuration]
    where S.Iterator.Element == RhythmTree<T>
{
    func merge(
        _ leaves: [RhythmLeaf<T>],
        into accum: [MetricalDuration],
        tied: MetricalDuration?
    ) -> [MetricalDuration]
    {
        
        guard let (leaf, remaining) = leaves.destructured else {
            return accum + tied
        }
        
        switch leaf.context {
            
        case .continuation:
            let tied = (tied ?? .zero) + leaf.metricalDuration
            return merge(remaining, into: accum, tied: tied)
            
        case .instance(let absenceOrEvent):
            let newAccum: [MetricalDuration]
            let newTied: MetricalDuration?
            switch absenceOrEvent {
            case .absence:
                newAccum = accum + tied + leaf.metricalDuration
                newTied = nil
            case .event:
                newAccum = accum + tied
                newTied = leaf.metricalDuration
            }
            
            return merge(remaining, into: newAccum, tied: newTied)
        }
    }
    
    return merge(rhythmTrees.flatMap { $0.tree.leaves }, into: [], tied: nil)
}

//extension Sequence where Iterator.Element == RhythmTree<Equatable> {
//    
//    /// - returns: Effective durations of events, merging tied durations.
//    public var lengths: [MetricalDuration] {
//        
//        
//    }
//}

/// - returns: `RhythmTree` with the given `MetricalDurationTree` and `MetricalContext` values.
public func * <T> (lhs: MetricalDurationTree, rhs: [MetricalContext<T>]) -> RhythmTree<T> {
    return RhythmTree(lhs, rhs)
}

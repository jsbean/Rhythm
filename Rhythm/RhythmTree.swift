//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

/// - Note: At some point, nest this within `Rhythm`, inheriting `T`. Currently, this produces
/// "Runtime Error: cyclic metadata dependency detected, aborting" (SR-4383).
public struct RhythmLeaf <T: Equatable> {
    
    public let metricalDuration: MetricalDuration
    public let context: MetricalContext<T>
    
    public init(metricalDuration: MetricalDuration, context: MetricalContext<T>) {
        self.metricalDuration = metricalDuration
        self.context = context
    }
}

public struct Rhythm <T: Equatable> {

    public let metricalDurationTree: MetricalDurationTree
    public let leaves: [RhythmLeaf<T>]
}

extension RhythmLeaf: Equatable {
    
    public static func == <T: Equatable> (lhs: RhythmLeaf<T>, rhs: RhythmLeaf<T>) -> Bool {
        return lhs.metricalDuration == rhs.metricalDuration && lhs.context == rhs.context
    }
}

extension Rhythm {
    
    public init(
        _ metricalDurationTree: MetricalDurationTree,
        _ leafContexts: [MetricalContext<T>]
    )
    {
        self.metricalDurationTree = metricalDurationTree
        self.leaves = zip(metricalDurationTree.leaves, leafContexts).map(RhythmLeaf.init)
    }
}

public func lengths <S: Sequence, T: Equatable> (of rhythmTrees: S) -> [MetricalDuration]
    where S.Iterator.Element == Rhythm<T>
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
    
    return merge(rhythmTrees.flatMap { $0.leaves }, into: [], tied: nil)
}

/// - returns: `RhythmTree` with the given `MetricalDurationTree` and `MetricalContext` values.
public func * <T> (lhs: MetricalDurationTree, rhs: [MetricalContext<T>]) -> Rhythm<T> {
    return Rhythm(lhs, rhs)
}

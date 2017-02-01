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
    
    case leaf(MetricalDuration)
    
    public init(_ metricalDuration: MetricalDuration, _ trees: [RhythmTree] = []) {
        self = .branch(metricalDuration, trees)
    }
}

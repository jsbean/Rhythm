//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections

/// Tree structure representing rhythm, parameratized over `T`.
public typealias RhythmTree <T> = Tree<MetricalLeaf<T>>

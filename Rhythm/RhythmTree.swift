//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections

public typealias RhythmTree<T> = Tree<
    ContinualOrInstance<
        AbsenceOrEvent<
            MetricDurationalContext<
                T
            >
        >
    >
>

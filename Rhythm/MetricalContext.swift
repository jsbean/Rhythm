//
//  MetricalContext.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// The metrical context of a given `Leaf` (i.e., whether or not the musical event is "tied"
/// from the previous event, and whether or not is a "rest" or an actual event.
public typealias MetricalContext <T> = ContinuationOrInstance<AbsenceOrEvent<T>>

infix operator • : MultiplicationPrecedence

public func • <T> (duration: MetricalDuration, context: MetricalContext<T>)
    -> MetricalLeaf<T>
{
    return MetricalLeaf(duration, context)
}

public func • <T> (context: MetricalContext<T>, duration: MetricalDuration)
    -> MetricalLeaf<T>
{
    return MetricalLeaf(duration, context)
}

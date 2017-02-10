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

/// Whether a context is a "rest" or an actual event of type `T`.
public enum AbsenceOrEvent <T> {
    
    /// "Rest".
    case absence
    
    /// Actual event of type `T`.
    case event(T)
}

extension AbsenceOrEvent: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        switch self {
        case .absence:
            return "<>"
        case .event(let value):
            return "\(value)"
        }
    }
}


/// Whether a metrical context is "tied" over from the previous context, or if it is new
/// instance of the generic `T`.
public enum ContinuationOrInstance <T> {
    
    /// "Tied" over from previous context.
    case continuation
    
    /// New instance of generic `T`.
    case instance(T)
}

extension ContinuationOrInstance: CustomStringConvertible {
    
    // MARK: - CustomStringConvertible
    
    /// Printed description.
    public var description: String {
        switch self {
        case .continuation:
            return "-"
        case .instance(let value):
            return "\(value)"
        }
    }
}




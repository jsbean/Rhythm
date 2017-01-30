//
//  AbsenceOrEvent.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

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
            return "()"
        case .event(let value):
            return "\(value)"
        }
    }
}

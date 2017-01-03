//
//  ContinuationOrInstance.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

/// Whether a metrical context is "tied" over from the previous context, or if it is new
/// instance of the generic `T`.
public enum ContinuationOrInstance <T> {
    
    /// "Tied" over from previous context.
    case continuation
    
    /// New instance of generic `T`.
    case instance(T)
}

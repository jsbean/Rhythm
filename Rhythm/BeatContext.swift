//
//  BeatContext.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

/// Information about a given beat within a `Meter`.
public struct BeatContext {
    
    /// Offset in amount of beats at given subdivision level from downbeat.
    ///
    /// - Note: Downbeat = 0
    public let position: Int

    /// Subdivision of `BeatContext`.
    public let subdivision: Int
}

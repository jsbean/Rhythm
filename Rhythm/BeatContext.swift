//
//  BeatContext.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

/// Information about a given beat within a `Meter`.
public struct BeatContext {

    // MARK: - Associated Types
    
    /// Type defining the placement of a beat in metered context
    public typealias Position = Int
    
    // MARK: - Instance Properties

    /// Subdivision of `BeatContext`.
    public let subdivision: Subdivision
    
    /// Offset in amount of beats at given subdivision level from downbeat.
    ///
    /// - Note: Downbeat = 0
    public let position: Position

    // MARK: - Initializers
    
    /// Creates a `BeatContext` with the given `subdivision` and `position`.
    public init(subdivision: Subdivision, position: Position) {
        self.subdivision = subdivision
        self.position = position
    }
}

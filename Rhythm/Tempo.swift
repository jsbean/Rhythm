//
//  Tempo.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

/// Model of a `Tempo`.
public struct Tempo {

    // MARK: - Associated Types
    
    public typealias BeatsPerMinute = Double

    // MARK: - Instance Properties

    /// Duration in seconds of a given beat.
    public var durationOfBeat: Double {
        return 60 / beatsPerMinute
    }

    /// Double value of `Tempo`.
    public var doubleValue: Double {
        return beatsPerMinute / Double(subdivision)
    }

    /// Value of `Tempo`.
    public let beatsPerMinute: BeatsPerMinute

    /// Subdivision of `Tempo`.
    ///
    /// - 1: whole note
    /// - 2: half note
    /// - 4: quarter note
    /// - 8: eighth note
    /// - 16: sixteenth note
    /// - ...
    public let subdivision: Subdivision

    // MARK: - Initializers

    /// Creates a `Tempo` with the given `value` for the given `subdivision`.
    public init(_ beatsPerMinute: BeatsPerMinute, subdivision: Subdivision = 4) {
        assert(subdivision != 0, "Cannot create a tempo with a subdivision of 0")
        self.beatsPerMinute = beatsPerMinute
        self.subdivision = subdivision
    }

    public func respelling(subdivision newSubdivision: Subdivision) -> Tempo {
        assert(newSubdivision.isPowerOfTwo, "Non-power-of-two subdivisions not yet supported")
        guard newSubdivision != subdivision else { return self }
        let quotient = Double(newSubdivision) / Double(subdivision)
        let newBeatsPerMinute = beatsPerMinute * quotient
        return Tempo(newBeatsPerMinute, subdivision: newSubdivision)
    }

    /// - returns: Duration for a beat at the given `subdivision`.
    public func duration(forBeatAt subdivision: Subdivision) -> Double {
        assert(subdivision.isPowerOfTwo, "Subdivision must be a power-of-two")
        let quotient = Double(subdivision) / Double(self.subdivision)
        return durationOfBeat / quotient
    }
}

extension Tempo: Equatable {

    // MARK: - Equatable

    /// - returns: `true` if `Tempo` values are equivalent. Otherwise, `false`.
    public static func == (lhs: Tempo, rhs: Tempo) -> Bool {
        return lhs.doubleValue == rhs.doubleValue
    }
}

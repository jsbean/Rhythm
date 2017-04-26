//
//  Tempo.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import Foundation

/// Model of a `Tempo`.
public struct Tempo {
    
    // MARK: - Instance Properties
    
    /// Duration in seconds of a given beat.
    public var durationOfBeat: Double {
        return 60 / value
    }
    
    /// Double value of `Tempo`.
    public var doubleValue: Double {
        return value / Double(subdivision)
    }
    
    /// Value of `Tempo`.
    public let value: Double
    
    /// 1 = whole note, 2 = half note, 4 = quarter note, 8 = eighth note, 16 = sixteenth note,
    /// etc.
    
    /// Subdivision of `Tempo`.
    ///
    /// - 1: whole note
    /// - 2: half note
    /// - 4: quarter note
    /// - 8: eighth note
    /// - 16: sixteenth note
    /// - ...
    public let subdivision: Int
    
    // MARK: - Initializers
    
    /// Creates a `Tempo` with the given `value` for the given `subdivision`.
    public init(_ value: Double, subdivision: Int = 4) {
        
        guard subdivision != 0 else {
            fatalError("Cannot create a tempo with a subdivision of 0")
        }
        
        self.value = value
        self.subdivision = subdivision
    }

    /// - returns: Duration for a beat at the given `subdivision`.
    public func duration(forBeatAt subdivision: Int) -> Double {
        
        guard subdivision.isPowerOfTwo else {
            fatalError("Subdivision must be a power-of-two")
        }
        
        let quotient = Double(subdivision) / Double(self.subdivision)
        return durationOfBeat / quotient
    }
}

extension Tempo {
    
    // MARK: - Equatable
    
    /// - returns: `true` if `Tempo` values are equivalent. Otherwise, `false.
    public static func == (lhs: Tempo, rhs: Tempo) -> Bool {
        return lhs.doubleValue == rhs.doubleValue
    }
}

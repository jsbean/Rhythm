//
//  Tempo.Item.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

extension Tempo {
    
    /// `Tempo.Interpolation` in a concrete range of `MetricalDuration` values.
    public struct Item {
        let interval: ClosedRange<MetricalDuration>
        let interpolation: Interpolation
    }
}

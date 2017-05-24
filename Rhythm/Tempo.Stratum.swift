//
//  Tempo.Stratum.swift
//  Rhythm
//
//  Created by James Bean on 5/23/17.
//
//

import Collections

extension Tempo {
    
    /// Collection of `Tempo.Item` values.
    public struct Stratum {
        
        // make this a computed property
        private var items: [Item]
        
        public init(_ items: [Item] = []) {
            self.items = items
        }
    }
}

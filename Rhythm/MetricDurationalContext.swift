//
//  MetricDurationalContext.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Foundation

public struct MetricDurationalContext <T> {
    
    public let event: T
    public let metricalDuration: MetricalDuration
    
    public init(event: T, metricalDuration: MetricalDuration) {
        self.event = event
        self.metricalDuration = metricalDuration
    }
}

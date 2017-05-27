//
//  MeterTests.swift
//  Rhythm
//
//  Created by James Bean on 4/26/17.
//
//

import XCTest
import Rhythm

class MeterTests: XCTestCase {
    
    func testTempoInit() {
        _ = Tempo(78, subdivision: 4)
    }
    
    func testTempoDurationAt60() {
        let tempo = Tempo(60)
        XCTAssertEqual(tempo.durationOfBeat, 1)
    }
    
    func testTempoDurationAt90() {
        let tempo = Tempo(90)
        XCTAssertEqual(tempo.durationOfBeat, (2/3))
    }
    
    func testTempoDurationAt30() {
        let tempo = Tempo(30)
        XCTAssertEqual(tempo.durationOfBeat, 2)
    }
    
    func testTempoDurationForBeatAtSubdivisionLevelSameAt60() {
        let tempo = Tempo(60, subdivision: 4)
        XCTAssertEqual(tempo.duration(forBeatAt: 4), 1)
    }
    
    func testTempoDurationForBeatAtSubdivisionLevelDoubleAt60() {
        let tempo = Tempo(60, subdivision: 4)
        XCTAssertEqual(tempo.duration(forBeatAt: 8), 0.5)
    }
    
    func testTempoDurationForBeatAtSubdivisionLevelHalfAt90() {
        let tempo = Tempo(90, subdivision: 8)
        XCTAssertEqual(tempo.duration(forBeatAt: 4), (2/3) * 2)
    }
    
    func testMeterBeatOffsets() {
        let meter = Meter(7,16)
        XCTAssertEqual(meter.beatOffsets, (0..<7).map { beat in beat/>16 })
    }
    
    func testStructureMeterOffsets() {
        let structure = Meter.Structure(meters: (0..<4).map { _ in Meter(4,4) })
        XCTAssertEqual(structure.meterOffsets, [0/>4, 4/>4, 8/>4, 12/>4])
    }
    
    func testStructureBeatOffsets() {
        let a = Meter(4,4)
        let b = Meter(3,16)
        let c = Meter(5,8)
        let structure = Meter.Structure(meters: [a,b,c])
        let result = structure.beatOffsets
        let expected = [
            0/>4,
            1/>4,
            2/>4,
            3/>4,
            4/>4,
            17/>16,
            18/>16,
            19/>16,
            21/>16,
            23/>16,
            25/>16,
            27/>16
        ]
        XCTAssertEqual(result, expected)
    }
}

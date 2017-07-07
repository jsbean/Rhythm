//
//  StratumTests.swift
//  Rhythm
//
//  Created by James Bean on 5/29/17.
//
//

import XCTest
import ArithmeticTools
@testable import Rhythm

class StratumTests: XCTestCase {
    
    func testBuilderSingleInterpolation() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero, interpolating: true)
        builder.addTempo(Tempo(90), at: 4/>4)
        let stratum = builder.build()
        // TODO: Assert
    }
    
    func testBuilderSingleStatic() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero)
        builder.addTempo(Tempo(90), at: 4/>4)
        let stratum = builder.build()
        print(stratum)
    }
    
    func testBuilderMultipleStatic() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(120), at: 3/>4)
        let stratum = builder.build()
        print(stratum)
    }

    func testSimpleFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero, interpolating: true)
        builder.addTempo(Tempo(120), at: 32/>4)
        let stratum = builder.build()
        let fragment = stratum.fragment(from: .zero, to: 32/>4)
        XCTAssertEqual(fragment.tempi.count, 1)
    }

    func testMoreComplexFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero, interpolating: true)
        builder.addTempo(Tempo(120), at: 16/>4, interpolating: false)
        builder.addTempo(Tempo(120), at: 32/>4, interpolating: true)
        builder.addTempo(Tempo(240), at: 64/>4, interpolating: false)
        let stratum = builder.build()
        let fragment = stratum.fragment(from: 8/>4, to: 48/>4)

        // [8 -> 16, 16 -> 32, 32 -> 48]
        XCTAssertEqual(fragment.tempi.count, 3)
    }

    func testFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero, interpolating: true)
        builder.addTempo(Tempo(30), at: 4/>4, interpolating: false)
        builder.addTempo(Tempo(120), at: 16/>4, interpolating: true)
        builder.addTempo(Tempo(60), at: 32/>4, interpolating: false)
        let stratum = builder.build()
        let fragment = stratum.fragment(from: 3/>4, to: 17/>4)

        // [3 -> 4, 4 -> 16, 16 -> 17]
        XCTAssertEqual(fragment.tempi.count, 3)
    }

    func testMeterStructureFragment() {

        // Builder Tempo.Stratum
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero, interpolating: true)
        builder.addTempo(Tempo(120), at: 16/>4, interpolating: false)
        builder.addTempo(Tempo(120), at: 32/>4, interpolating: true)
        builder.addTempo(Tempo(240), at: 64/>4, interpolating: false)
        let tempi = builder.build()
        let meters = (0..<16).map { _ in Meter(4,4) }
        let structure = Meter.Structure(meters: meters, tempi: tempi)
        let fragment = structure.fragment(from: 7/>4, to: 48/>4)
        XCTAssertEqual(fragment.tempi.tempi.count, 3)
    }

    func testFragmentWithZeros() {

        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(60), at: .zero, interpolating: true)
        builder.addTempo(Tempo(120), at: 180/>4, interpolating: false)
        let stratum = builder.build()

        let meters = (0..<44).map { _ in return Meter(4,4) }
        let meterStructure = Meter.Structure(meters: meters, tempi: stratum)

        let ranges = (0..<35).map { _ in MetricalDuration(5,4) }.accumulatingRight.adjacentPairs!
        let fragments = ranges.map { start, end in meterStructure.fragment(from: start, to: end) }
    }

    func testFragmentsFromTutschkuUnder() {

        let builder = Tempo.Stratum.Builder()

        let meters = [
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(3,4),
            Meter(3,8),
            Meter(7,4),
            Meter(8,4),
            Meter(8,4),
            Meter(8,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,8),
            Meter(5,8),
            Meter(7,4),
            Meter(7,4),
            Meter(3,8),
            Meter(2,4),
            Meter(1,8),
            Meter(6,4),
            Meter(6,4),
            Meter(5,8),
            Meter(7,4),
            Meter(1,8),
            Meter(7,4),
            Meter(5,8),
            Meter(2,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,8),
            Meter(2,4),
            Meter(5,8),
            Meter(7,4),
            Meter(3,8),
            Meter(1,8),
            Meter(7,4),
            Meter(1,8),
            Meter(2,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(6,4),
            Meter(7,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(7,4),
            Meter(6,4),
            Meter(3,4),
            Meter(4,4),
            Meter(5,4),
            Meter(7,4),
            Meter(6,4),
            Meter(7,4),
            Meter(7,4),
            Meter(3,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(6,4),
            Meter(5,4),
            Meter(6,4),
            Meter(7,4),
            Meter(5,4),
            Meter(6,4),
            Meter(6,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(6,4),
            Meter(3,4),
            Meter(5,4),
            Meter(7,4),
            Meter(3,4),
            Meter(1,4),
            Meter(5,4),
            Meter(7,4),
            Meter(1,4),
            Meter(7,4),
            Meter(2,4),
            Meter(5,4),
            Meter(3,4),
            Meter(1,4),
            Meter(7,4),
            Meter(2,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(3,4),
            Meter(5,4),
            Meter(1,4),
            Meter(7,4),
            Meter(3,4),
            Meter(7,4),
            Meter(5,4),
            Meter(2,4),
            Meter(4,4),
            Meter(4,4),
            Meter(6,4),
            Meter(2,4),
            Meter(8,4),
            Meter(8,4),
            Meter(1,4),
            Meter(4,4),
            Meter(2,4),
            Meter(5,4),
            Meter(4,4),
            Meter(1,4),
            Meter(4,4),
            Meter(1,4),
            Meter(7,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(5,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(2,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(6,4),
            Meter(3,4),
            Meter(7,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(3,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(3,8),
            Meter(3,4),
            Meter(1,8),
            Meter(3,8),
            Meter(1,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(1,4),
            Meter(1,8),
            Meter(3,4),
            Meter(1,8),
            Meter(5,4),
            Meter(1,8),
            Meter(3,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(5,4),
            Meter(3,4),
            Meter(7,4),
            Meter(1,4),
            Meter(5,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4),
            Meter(7,4)
        ]

        let eventOffsets = [
            MetricalDuration(0,8),
            MetricalDuration(31,8),
            MetricalDuration(69,8),
            MetricalDuration(99,8),
            MetricalDuration(127,8),
            MetricalDuration(147,8),
            MetricalDuration(230,8),
            MetricalDuration(288,8),
            MetricalDuration(332,8),
            MetricalDuration(356,8),
            MetricalDuration(398,8),
            MetricalDuration(416,8),
            MetricalDuration(505,8),
            MetricalDuration(561,8),
            MetricalDuration(603,8),
            MetricalDuration(643,8),
            MetricalDuration(667,8),
            MetricalDuration(691,8),
            MetricalDuration(727,8),
            MetricalDuration(751,8),
            MetricalDuration(775,8),
            MetricalDuration(801,8),
            MetricalDuration(825,8),
            MetricalDuration(851,8),
            MetricalDuration(875,8),
            MetricalDuration(901,8),
            MetricalDuration(939,8),
            MetricalDuration(965,8),
            MetricalDuration(997,8),
            MetricalDuration(1033,8),
            MetricalDuration(1069,8),
            MetricalDuration(1103,8),
            MetricalDuration(1139,8),
            MetricalDuration(1162,8),
            MetricalDuration(1175,8),
            MetricalDuration(1205,8),
            MetricalDuration(1237,8),
            MetricalDuration(1257,8),
            MetricalDuration(1293,8),
            MetricalDuration(1323,8),
            MetricalDuration(1357,8),
            MetricalDuration(1387,8),
            MetricalDuration(1419,8),
            MetricalDuration(1455,8),
            MetricalDuration(1465,8),
            MetricalDuration(1487,8),
            MetricalDuration(1497,8),
            MetricalDuration(1513,8),
            MetricalDuration(1531,8),
            MetricalDuration(1547,8),
            MetricalDuration(1565,8),
            MetricalDuration(1585,8),
            MetricalDuration(1591,8),
            MetricalDuration(1609,8),
            MetricalDuration(1675,8),
            MetricalDuration(1695,8),
            MetricalDuration(1719,8),
            MetricalDuration(1735,8),
            MetricalDuration(1756,8),
            MetricalDuration(1795,8),
            MetricalDuration(1825,8),
            MetricalDuration(1855,8),
            MetricalDuration(1895,8),
            MetricalDuration(1951,8),
            MetricalDuration(1993,8),
            MetricalDuration(2035,8)
        ]
    }
}


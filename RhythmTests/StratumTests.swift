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
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(90), at: 4/>4)
        let stratum = builder.build()
        // TODO: Assert
    }
    
    func testBuilderSingleStatic() {
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero)
        builder.add(Tempo(90), at: 4/>4)
        let stratum = builder.build()
        print(stratum)
    }
    
    func testBuilderMultipleStatic() {
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(120), at: 3/>4)
        let stratum = builder.build()
        print(stratum)
    }

    func testSimpleFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(120), at: 32/>4)
        let stratum = builder.build()
        let fragment = stratum.fragment(from: .zero, to: 32/>4)
        dump(fragment)
    }

    func testMoreComplexFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(120), at: 16/>4, interpolating: false)
        builder.add(Tempo(120), at: 32/>4, interpolating: true)
        builder.add(Tempo(240), at: 64/>4, interpolating: false)
        let stratum = builder.build()
        let fragment = stratum.fragment(from: 8/>4, to: 48/>4)
        dump(fragment)
    }

    func testFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(30), at: 4/>4, interpolating: false)
        builder.add(Tempo(120), at: 16/>4, interpolating: true)
        builder.add(Tempo(60), at: 32/>4, interpolating: false)
        let stratum = builder.build()
        let fragment = stratum.fragment(from: 3/>4, to: 17/>4)
        dump(fragment)
    }

    func testMeterStructureFragment() {

        // Builder Tempo.Stratum
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(120), at: 16/>4, interpolating: false)
        builder.add(Tempo(120), at: 32/>4, interpolating: true)
        builder.add(Tempo(240), at: 64/>4, interpolating: false)
        let tempi = builder.build()
        let meters = (0..<16).map { _ in Meter(4,4) }
        let structure = Meter.Structure(meters: meters, tempi: tempi)
        let fragment = structure.fragment(from: 7/>4, to: 48/>4)
        dump(fragment)
    }

    func testFragmentWithZeros() {

        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(120), at: 180/>4, interpolating: false)
        let stratum = builder.build()

        let meters = (0..<44).map { _ in return Meter(4,4) }
        let meterStructure = Meter.Structure(meters: meters, tempi: stratum)

        let ranges = (0..<35).map { _ in MetricalDuration(5,4) }.accumulatingRight.adjacentPairs!
        let fragments = ranges.map { start, end in meterStructure.fragment(from: start, to: end) }
        dump(fragments)
    }

    func testFragments() {

        let builder = Tempo.Stratum.Builder()

        // Add tempos
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(120), at: 180/>4, interpolating: false)

        // Add meters
        (0..<44).forEach { _ in builder.add(Meter(4,4)) }

        let ranges = [0/>4...13/>4, 13/>4...19/>4, 19/>4]

        let scoreModel = builder.build()
    }
}


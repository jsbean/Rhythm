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

    func testTempoStratumFragment() {
        let builder = Tempo.Stratum.Builder()
        builder.addTempo(Tempo(70), at: .zero)
        builder.addTempo(Tempo(55), at: 70/>4)
        builder.addTempo(Tempo(70), at: 98/>4)
        builder.addTempo(Tempo(55), at: 100/>4)
        builder.addTempo(Tempo(70), at: 154/>4)
        let tempoStratum = builder.build()
        let fragment = tempoStratum.fragment(from: 333/>16, to: 513/>16)
        XCTAssertEqual(fragment.tempi.count, 3)
        // Assert keys
    }
}


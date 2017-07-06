//
//  StratumTests.swift
//  Rhythm
//
//  Created by James Bean on 5/29/17.
//
//

import XCTest
@testable import Rhythm

class StratumTests: XCTestCase {
    
    // test empty, etc
    
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

    func testSegment() {
        let builder = Tempo.Stratum.Builder()
        builder.add(Tempo(60), at: .zero, interpolating: true)
        builder.add(Tempo(30), at: 4/>4, interpolating: false)
        builder.add(Tempo(120), at: 16/>4, interpolating: true)
        builder.add(Tempo(60), at: 32/>4, interpolating: false)
        let stratum = builder.build()
        print(stratum)
    }
}

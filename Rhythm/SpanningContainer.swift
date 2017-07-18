//
//  SpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Collections
import ArithmeticTools

// FIXME: Move to dn-m/Collections
public protocol SpanningContainer: RandomAccessCollectionWrapping, Spanning, Fragmentable {
    associatedtype Spanner: SpanningFragment
    var base: SortedDictionary<Spanner.Metric,Spanner> { get }
    init(_: SortedDictionary<Spanner.Metric,Spanner>)
    init <S> (_: S) where S: Sequence, S.Iterator.Element == Spanner
}

extension SpanningContainer {

    public func spanners(in range: CountableClosedRange<Int>) -> [Spanner] {
        return range.map { index in base.values[index] }
    }
}

//extension SpanningContainer where Spanner.Fragment == Spanner, Spanner.Metric == Metric {
//
//    // FIXME: Abstract to `SpanningContainer`.
//    public var length: Spanner.Fragment.Metric {
//        return base.values.map { $0.length }.sum
//    }
//}

//
//    // FIXME: Move to `SpanningContainer`.
//    public func element(from offset: Metric, at index: Int) -> Spanner {
//        let (elementOffset, fragment) = base[index]
//        return fragment.from(offset - elementOffset)
//    }
//
//    // FIXME: Move to `SpanningContainer`.
//    public func element(to offset: Metric, at index: Int) -> Spanner {
//        let (elementOffset, fragment) = base[index]
//        return fragment.to(offset - elementOffset)
//    }
//}

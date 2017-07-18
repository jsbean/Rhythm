//
//  SpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Algebra
import Collections
import ArithmeticTools

// FIXME: Conform SpanningContainer to Additive

// FIXME: Move to dn-m/Collections
public protocol SpanningContainer: RandomAccessCollectionWrapping, Spanning, Fragmentable {
    associatedtype Spanner: SpanningFragment
    var base: SortedDictionary<Spanner.Metric,Spanner> { get }
    init(_: SortedDictionary<Spanner.Metric,Spanner>)
    init <S> (_: S) where S: Sequence, S.Iterator.Element == Spanner
}

extension SpanningContainer {

    public static var zero: Self { return Self([]) }

    public func spanners(in range: CountableClosedRange<Int>) -> [Spanner] {
        return range.map { index in base.values[index] }
    }
}

// FIXME: Use constrained associated types in Swift 4
extension SpanningContainer where Spanner == Spanner.Fragment, Metric == Spanner.Metric {

    public var length: Metric {
        return base.values.map { $0.length }.sum
    }

    public func contains(_ target: Metric) -> Bool {
        return (.zero ..< length).contains(target)
    }

    public subscript (range: Range<Metric>) -> Self {

        assert(range.lowerBound >= .zero)

        guard range.lowerBound < length else {
            return .zero
        }

        let range = range.upperBound > length ? range.lowerBound ..< length : range
        guard let startIndex = indexOfElement(containing: range.lowerBound) else {
            return .zero
        }

        let endIndex = indexOfElement(containing: range.upperBound, includingUpperBound: true)
            ?? base.count - 1

        if endIndex == startIndex {
            let (offset, element) = base[startIndex]
            return .init([element[range.lowerBound - offset ..< range.upperBound - offset]])
        }

        let start = element(from: range.lowerBound, at: startIndex)
        let end = element(to: range.upperBound, at: endIndex)

        if endIndex == startIndex + 1 {
            return .init([start,end])
        }

        let innards = spanners(in: startIndex + 1 ... endIndex - 1)
        return .init(start + innards + end)
    }

    public func element(from offset: Metric, at index: Int) -> Spanner {
        let (elementOffset, fragment) = base[index]
        return fragment.from(offset - elementOffset)
    }

    public func element(to offset: Metric, at index: Int) -> Spanner {
        let (elementOffset, fragment) = base[index]
        return fragment.to(offset - elementOffset)
    }

    /// - Parameters:
    ///   - includingUpperBound: Whether or not to include the `upperBound` of the `element.range`
    ///     in the search, and to dismiss the `lowerBound`.
    ///
    /// - Returns: The index of the element containing the given `target` offset.
    ///
    // FIXME: It feels gross to have to duplicate this code.
    public func indexOfElement(containing target: Metric, includingUpperBound: Bool = false)
        -> Int?
    {

        var start = 0
        var end = base.count

        while start < end {

            let mid = start + (end - start) / 2
            let (offset, element) = base[mid]
            let lowerBound = offset
            let upperBound = offset + element.range.length
            if includingUpperBound {
                if target > lowerBound && target <= upperBound {
                    return mid
                } else if target > upperBound {
                    start = mid + 1
                } else {
                    end = mid
                }
            } else {
                if target >= lowerBound && target < upperBound {
                    return mid
                } else if target >= offset + element.range.length {
                    start = mid + 1
                } else {
                    end = mid
                }
            }
        }
        
        return nil
    }
}


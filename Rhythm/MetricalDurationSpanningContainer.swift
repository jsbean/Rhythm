//
//  MetricalDurationSpanningContainer.swift
//  Rhythm
//
//  Created by James Bean on 7/13/17.
//
//

import Collections
import ArithmeticTools

/// - Precondition: n + n.length = m
// FIXME: Use constrained associated types in Swift 4:
// https://github.com/apple/swift-evolution/blob/master/proposals/0142-associated-types-constraints.md
public protocol MetricalDurationSpanningContainer: SpanningContainer, MetricalDurationSpanning {

    // MARK: - Associated Types

    /// `MetricalDurationSpanningFragment`
    associatedtype Spanner: MetricalDurationSpanningFragment

    // MARK: - Instance Properties

    /// `MetricalDurationSpanningFragment` base, stored by their offset.
    ///
    // FIXME: This declaration should not be neceesary.
    var base: SortedDictionary<Fraction,Spanner> { get }
}

extension MetricalDurationSpanningContainer where Spanner.Metric == Metric {

    // MARK: - Spanning

    // FIXME: Abstract to `SpanningContainer`.
    public var length: Fraction {
        return base.values.map { $0.length }.sum
    }
}

// FIXME: This method should not require this constraint. Will be evident in the type in Swift 4.
extension MetricalDurationSpanningContainer where Spanner.Fragment == Spanner, Spanner.Metric == Metric {

    public subscript (range: Range<Fraction>) -> Self {

        assert(range.lowerBound >= .unit)

        guard range.lowerBound < length else {
            return .init([])
        }

        let range = range.upperBound > length ? range.lowerBound ..< length : range

        guard let startIndex = indexOfElement(containing: range.lowerBound) else {
            return .init([])
        }

        let endIndex = (
            indexOfElement(containing: range.upperBound, includingUpperBound: true)
                ?? base.count - 1
        )

        let start = element(from: range.lowerBound, at: startIndex)

        // Single interpolation
        if endIndex == startIndex {
            let (offset, element) = base[startIndex]
            return .init([element[range.lowerBound - offset ..< range.upperBound - offset]])
        }

        let end = element(to: range.upperBound, at: endIndex)

        /// Two consecutive measures
        guard endIndex > startIndex + 1 else {
            return .init([start,end])
        }

        /// Three or more measures
        let innards = base(in: startIndex + 1 ... endIndex - 1)
        return .init(start + innards + end)
    }


    public func element(from offset: Fraction, at index: Int) -> Spanner {
        let (elementOffset, fragment) = base[index]
        return fragment.from(offset - elementOffset)
    }

    public func element(to offset: Fraction, at index: Int) -> Spanner {
        let (elementOffset, fragment) = base[index]
        return fragment.to(offset - elementOffset)
    }

    public func base(in range: CountableClosedRange<Int>) -> [Spanner] {
        return range
            .lazy
            .map { index in self.base[index] }
            .map { _, element in element }
    }

    /// - Parameters:
    ///   - includingUpperBound: Whether or not to include the `upperBound` of the `element.range`
    ///     in the search, and to dismiss the `lowerBound`.
    ///
    /// - Returns: The index of the element containing the given `target` offset.
    ///
    // FIXME: It feels gross to have to duplicate this code.
    func indexOfElement(containing target: Fraction, includingUpperBound: Bool = false) -> Int? {

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

extension MetricalDurationSpanningContainer where Spanner.Metric == Metric {
    
    public func contains(_ target: Fraction) -> Bool {
        return (.unit ..< length).contains(target)
    }
}

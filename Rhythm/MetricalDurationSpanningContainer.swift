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
public protocol MetricalDurationSpanningContainer: SpanningContainer, MetricalDurationSpanning {

    // MARK: - Associated Types

    /// `MetricalDurationSpanningFragment`
    associatedtype Element: MetricalDurationSpanningFragment

    /// `MetricalDurationSpanningFragment` elements, stored by their offset.
    var elements: SortedDictionary<Fraction,Element> { get }

    /// Creates a `MetricalDurationSpanningContainer` with the given `elements`.
    init(_ elements: SortedDictionary<Fraction,Element>)

    /// Creates a `MetricalDurationSpanningContainer` with the given `elements` in order, stored by
    /// their cumulative offset.
    init <S> (_ elements: S) where S: Sequence, S.Iterator.Element == Element
}

// FIXME: This method should not require this constraint. Will be evident in the type in Swift 4.
extension MetricalDurationSpanningContainer where Element.Fragment == Element {

    public subscript (range: Range<Fraction>) -> Self {

        assert(range.lowerBound >= .unit)

        guard range.lowerBound < duration else {
            return .init([])
        }

        let range = range.upperBound > duration ? range.lowerBound ..< duration : range

        guard let startIndex = indexOfElement(containing: range.lowerBound) else {
            return .init([])
        }

        let endIndex = (
            indexOfElement(containing: range.upperBound, includingUpperBound: true)
                ?? elements.count - 1
        )

        let start = element(from: range.lowerBound, at: startIndex)

        // Single interpolation
        if endIndex == startIndex {
            let (offset, element) = elements[startIndex]
            return .init([element[range.lowerBound - offset ..< range.upperBound - offset]])
        }

        let end = element(to: range.upperBound, at: endIndex)

        /// Two consecutive measures
        guard endIndex > startIndex + 1 else {
            return .init([start,end])
        }

        /// Three or more measures
        let innards = elements(in: startIndex + 1 ... endIndex - 1)
        return .init(start + innards + end)
    }


    public func element(from offset: Fraction, at index: Int) -> Element {
        let (elementOffset, fragment) = elements[index]
        return fragment.from(offset - elementOffset)
    }

    public func element(to offset: Fraction, at index: Int) -> Element {
        let (elementOffset, fragment) = elements[index]
        return fragment.to(offset - elementOffset)
    }

    public func elements(in range: CountableClosedRange<Int>) -> [Element] {
        return range
            .lazy
            .map { index in self.elements[index] }
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
        var end = elements.count

        while start < end {

            let mid = start + (end - start) / 2
            let (offset, element) = elements[mid]

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

extension MetricalDurationSpanningContainer {

    public var duration: Fraction {
        guard let (offset, element) = elements.last else { return .unit }
        return offset + element.range.length
    }
    
    public func contains(_ target: Fraction) -> Bool {
        return (.unit ..< duration).contains(target)
    }
}
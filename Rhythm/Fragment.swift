//
//  Fragment.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

import Collections
import ArithmeticTools

protocol Fragmentable {
    associatedtype Fragment
    subscript(range: Range<Fraction>) -> Fragment { get }
}

protocol DuratedFragment: Fragmentable {
    associatedtype Base: Fragmentable
    var base: Base { get }
    var range: Range<Fraction> { get }
}

extension DuratedFragment {

    func from(_ offset: Fraction) -> Fragment {
        assert(offset >= self.range.lowerBound)
        let range = offset ..< self.range.upperBound
        return self[range]
    }

    func to(_ offset: Fraction) -> Fragment {
        assert(offset < self.range.upperBound)
        let range = self.range.lowerBound ..< offset
        return self[range]
    }
}

/// - Precondition: n + n.length = m
/// Perhaps add Collection protocol requirements
protocol DuratedContainer: Fragmentable {
    associatedtype Element: DuratedFragment
    var elements: SortedDictionary<Fraction,Element> { get }
}

extension DuratedContainer {

    var duration: Fraction {
        guard let (offset, element) = elements.last else { return .unit }
        return offset + element.range.length
    }

    func contains(_ target: Fraction) -> Bool {
        return (.unit ..< duration).contains(target)
    }

    /// - Returns: The index of the element containing the given `target` offset.
    func indexOfElement(containing target: Fraction) -> Int? {

        var start = 0
        var end = elements.count

        while start < end {

            let mid = start + (end - start) / 2
            let (offset, element) = elements[mid]
            let range = element.range.shifted(by: offset)

            if range.contains(target) {
                return mid
            } else if target >= range.upperBound {
                start = mid + 1
            } else {
                end = mid
            }
        }

        return nil
    }
}

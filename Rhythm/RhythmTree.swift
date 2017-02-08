//
//  RhythmTree.swift
//  Rhythm
//
//  Created by James Bean on 1/3/17.
//
//

import Collections
import ArithmeticTools

/// Tree structure representing rhythm, parameratized over `T`.
public enum RhythmTree {

    indirect case branch(MetricalDuration, [RhythmTree])
    
    case leaf(MetricalDuration, MetricalContext<Int>)
    
    public var metricalDuration: MetricalDuration {
        
        switch self {
        case .leaf(let duration, _):
            return duration
        case .branch(let duration, _):
            return duration
        }
    }
    
    public init(_ metricalDuration: MetricalDuration, _ relativeDurations: [Int]) {
        
        let beats = metricalDuration.numerator
        let subdivision = metricalDuration.denominator
        let tree = ProportionTree(beats, relativeDurations)
        let normalizedTree = tree |> normalized

        let (old, new) = (beats, normalizedTree.value)
        let multiplier = Double(new) / Double(old)
        let newSubdivision = Int(Double(subdivision) * multiplier)
        
        self = RhythmTree(subdivision: newSubdivision, relativeDurationTree: normalizedTree)
    }
    
    public init(subdivision: Int, relativeDurationTree: ProportionTree) {
        
        let relativeDurationTree = relativeDurationTree |> normalized
        let metricalDurationTree = relativeDurationTree.map { $0 /> subdivision }
        
        func traverse(_ tree: MetricalDurationTree) -> RhythmTree {
            
            switch tree {
            case .leaf(let value):
                return .leaf(value, .instance(.event(0)))
            case .branch(let value, let trees):
                return .branch(value, trees.map(traverse))
            }
        }
        
        self = traverse(metricalDurationTree)
    }
    
    public func with(metricalDuration: MetricalDuration) -> RhythmTree {
        switch self {
        case .leaf(_, let context):
            return .leaf(metricalDuration, context)
        case .branch(_, let trees):
            return .branch(metricalDuration, trees)
        }
    }
    
    public var leaves: [(MetricalDuration, MetricalContext<Int>)] {
        
        func flattened(
            accum: [(MetricalDuration, MetricalContext<Int>)],
            tree: RhythmTree
        ) -> [(MetricalDuration, MetricalContext<Int>)]
        {
            switch tree {
            case .branch(_, let trees):
                return trees.reduce(accum, flattened)
            case .leaf(let duration, let context):
                return accum + [(duration, context)]
            }
        }
        
        return flattened(accum: [], tree: self)
    }
    
    public func inserting(tree: RhythmTree, at index: Int) throws -> RhythmTree {

        switch self {
        case .leaf(let duration, _):
            return .branch(duration, [tree])
        case .branch(let metricalDuration, let trees):
            
            guard let (left, right) = trees.split(at: index) else {
                fatalError("Index out of range")
            }

            return .branch(metricalDuration, left + tree + right)
        }
    }
}

extension RhythmTree: CustomStringConvertible {
    
    /// Printed description.
    public var description: String {
        
        func indents(_ amount: Int, value: String = "  ") -> String {
            return (0 ..< amount).reduce("") { accum, _ in accum + value }
        }
        
        func traverse(tree: RhythmTree, indentation: Int = 0) -> String {
            
            switch tree {
            case .leaf(let value):
                return indents(indentation) + "\(value)"
            case .branch(let value, let trees):
                return (
                    indents(indentation) + "\(value)\n" +
                        trees
                            .map { traverse(tree: $0, indentation: indentation + 1) }
                            .joined(separator: "\n")
                )
            }
        }
        
        return traverse(tree: self)
    }
}

/// - TODO: Refine
public func << (metricalDuration: MetricalDuration, relativeDurations: [Int]) -> RhythmTree {
    return RhythmTree(metricalDuration, relativeDurations)
}

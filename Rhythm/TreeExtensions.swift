//
//  TreeExtensions.swift
//  Rhythm
//
//  Created by James Bean on 2/8/17.
//
//

import Collections

extension Tree {
    
    /// Create an arbitrarily-nested tree with an array. 
    ///
    /// Modeled after OpenMusic's `RhythmTree` notation.
    ///
    /// A single-depth tree looks like this:
    ///
    ///     let singleDepth = [1, [1,2,3]]
    ///
    /// A multi-depth tree looks like this:
    ///
    ///     let multiDepth = [1, [1,[2,[1,2,[3,[1,2,3]]]],3]]
    ///
    /// Good luck.
    public init(_ value: [Any]) {
        
        func traverse(_ value: Any) -> Tree<T> {
            
            // Input: `T`
            if let leaf = value as? T {
                return .leaf(leaf)
            }
            
            // Input: `[Any]`
            guard
                let branch = value as? [Any],
                let (head, tail) = branch.destructured
            else {
                fatalError()
            }
            
            switch head {
                
            // Input: `[T, ...]`
            case let value as T:
                
                // Input: `[T]`
                if tail.isEmpty {
                    return .branch(value, branch.map(traverse))
                }
                
                // Input: `[T, [...]]`
                guard
                    tail.count == 1,
                    let children = tail.first as? [Any]
                else {
                    fatalError()
                }
                
                return .branch(value, children.map(traverse))
                
            // Input: `[[T ... ], ... ]`
            case let branch as [Any]:
                return traverse(branch)
                
            default:
                fatalError()
            }
        }
        
        self = traverse(value)
    }
}

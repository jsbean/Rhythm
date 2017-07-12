//
//  Builder.swift
//  Rhythm
//
//  Created by James Bean on 7/12/17.
//
//

protocol BuilderProtocol {
    associatedtype Product
    func build() -> Product
}

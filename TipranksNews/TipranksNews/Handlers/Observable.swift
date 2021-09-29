//
//  Observable.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

public final class Observable<Value> {

    private var closure: ((Value) -> ())?

    public var value: Value {
        didSet { closure?(value) }
    }

    public init(_ value: Value) {
        self.value = value
    }

    public func observe(_ closure: @escaping (Value) -> Void) {
        self.closure = closure
        closure(value)
    }
}

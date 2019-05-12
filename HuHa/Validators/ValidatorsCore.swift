//
//  ValidatorsCore.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 12/05/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import Foundation

//-------------------------------------------------------

extension String: Error {}
extension Array: Error where Element == Error {}

typealias Validated<T: Equatable> = Result<T, [Error]>

func zip<A>(_ va: Validated<A>, _ vb: Validated<A>) -> Validated<A> {
    switch (va, vb) {
    case let (.success(a), .success(b)):
        guard a == b else {
            return .failure(["\(a) != \(b)"])
        }
        return .success(a)
    case let (.failure(e1), .failure(e2)):
        return .failure(e1 + e2)
    case let (_, .failure(e)):
        return .failure(e)
    case let (.failure(e), _):
        return .failure(e)
    }
}

struct Validator<T,U: Equatable> {
    let validate: (T) -> Validated<U>
    
    func then<W>(_ other: Validator<U,W>) -> Validator<T,W> {
        return Validator<T,W> { input in
            return self.validate(input).flatMap(other.validate)
        }
    }
    
    func and(_ other: Validator<T,U>) -> Validator<T,U> {
        return zip(self, other)
    }
    
    func with(_ error: Error) -> Validator<T,U> {
        return Validator<T,U> { input in
            return self.validate(input).flatMapError({_ in return .failure([error])})
        }
    }
}

func zip<A,B>(_ lhs: Validator<A,B>, _ rhs: Validator<A, B>) -> Validator<A,B> {
    return Validator<A,B> { a in
        return zip(lhs.validate(a), rhs.validate(a))
    }
}

//-------------------------------

precedencegroup ApplyPrecedence {
    associativity: left
}

precedencegroup SequentialPrecedence {
    higherThan: ApplyPrecedence
    associativity: left
}

precedencegroup ParallelPrecedence {
    higherThan: SequentialPrecedence
    associativity: left
}

infix operator |>: ApplyPrecedence
infix operator >>>: SequentialPrecedence
infix operator >&>: ParallelPrecedence

func |><A,B>(_ a: A, f: (A) -> B) -> B {
    return f(a)
}

func |><A,B>(_ a: A, f: Validator<A,B>) -> Validated<B> {
    return f.validate(a)
}

func >>><A,B,C>(_ lhs: Validator<A,B>, _ rhs: Validator<B,C>) -> Validator<A,C> {
    return lhs.then(rhs)
}

func >&><A,B>(_ lhs: Validator<A,B>, _ rhs: Validator<A,B>) -> Validator<A,B> {
    return lhs.and(rhs)
}

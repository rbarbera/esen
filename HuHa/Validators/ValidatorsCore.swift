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

struct Validator<T,U: Equatable> {
    let validate: (T) -> Validated<U>
    
    func then<W>(_ other: Validator<U,W>) -> Validator<T,W> {
        return Validator<T,W> { input in
            return self.validate(input).flatMap(other.validate)
        }
    }
    
    func and(_ other: Validator<T,U>) -> Validator<T,U> {
        return Validator<T,U> { input in
            switch (self.validate(input), other.validate(input)) {
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
    }

    func or(_ other: Validator<T,U>) -> Validator<T,U> {
        return Validator<T,U> { input in
            switch (self.validate(input), other.validate(input)) {
            case let (.success(a), .success(b)):
                guard a == b else {
                    return .failure(["\(a) != \(b)"])
                }
                return .success(a)
            case let (.success(a), _):
                return .success(a)
            case let (_, .success(b)):
                return .success(b)
            case let (.failure(e1), .failure(e2)):
                return .failure(e1 + e2)
            }
        }
    }

    func with(_ error: Error) -> Validator<T,U> {
        return Validator<T,U> { input in
            return self.validate(input).flatMapError({_ in return .failure([error])})
        }
    }
}


//-------------------------------

precedencegroup ApplyPrecedence {
    higherThan: AssignmentPrecedence
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
infix operator <&>: ParallelPrecedence
infix operator <|>: ParallelPrecedence

func |><A,B>(_ a: A, f: (A) -> B) -> B {
    return f(a)
}

func |><A,B>(_ a: A, f: Validator<A,B>) -> Validated<B> {
    return f.validate(a)
}

func >>><A,B,C>(_ lhs: Validator<A,B>, _ rhs: Validator<B,C>) -> Validator<A,C> {
    return lhs.then(rhs)
}

func <&><A,B>(_ lhs: Validator<A,B>, _ rhs: Validator<A,B>) -> Validator<A,B> {
    return lhs.and(rhs)
}

func <|><A,B>(_ lhs: Validator<A,B>, _ rhs: Validator<A,B>) -> Validator<A,B> {
    return lhs.or(rhs)
}

//-----------------------------------------------

extension Validator where T == Int, U == Int {
    static let valid = Validator<Int,Int> { i in return .success(i) }
    static let invalid = Validator<Int,Int> { _ in return .failure([]) }
}

import Foundation

extension String: Error {}
extension Array: Error where Element == Error {}

typealias Validated<A> = Result<A, [Error]>

struct Validator<A,B: Equatable> {
    let run: (A) -> Validated<B>
}

extension Validator {
    func then<C>(_ other: Validator<B,C>) -> Validator<A,C> {
        return Validator<A,C> { input in
            self.run(input).flatMap(other.run)
        }
    }
    
    func and(_ other: Validator<A,B>) -> Validator<A,B> {
        return Validator<A,B> { input in
            switch (self.run(input), other.run(input)) {
            case let (.success(s1), .success(s2)):
                guard s1 == s2 else {
                    return .failure(["\(s1) != \(s2)"])
                }
                return .success(s1)
            case let (.failure(e1), .failure(e2)):
                return .failure(e1 + e2)
            case let (.failure(e1), _):
                return .failure(e1)
            case let (_, .failure(e2)):
                return .failure(e2)
            }
        }
    }
    func or(_ other: Validator<A,B>) -> Validator<A,B> {
        return Validator<A,B> { input in
            switch (self.run(input), other.run(input)) {
            case let (.success(s1), .success(s2)):
                guard s1 == s2 else {
                    return .failure(["\(s1) != \(s2)"])
                }
                return .success(s1)
            case let (.failure(e1), .failure(e2)):
                return .failure(e1 + e2)
            case let (.success(s1), _):
                return .success(s1)
            case let (_, .success(s2)):
                return .success(s2)
            }
        }
    }
}

//----------------------------------------------------------------------

precedencegroup ApplicationPrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup SequentialPrecedence {
    associativity: left
    higherThan: ApplicationPrecedence
}

precedencegroup ParallelPrecedence {
    associativity: left
    higherThan: SequentialPrecedence
}

infix operator |>: ApplicationPrecedence
infix operator >>>: SequentialPrecedence
infix operator <&>: ParallelPrecedence
infix operator <|>: ParallelPrecedence

// General application
func |><A,B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    return f(a)
}

// Specialiced application that knows the structure of Validator
func |><A,B>(_ a: A, _ v: Validator<A,B>) -> Validated<B> {
    return v.run(a)
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

//----------------------------------------------------------------------

func lessOrEqual(_ limit: Int) -> Validator<Int,Int> {
    return Validator<Int,Int> { input in
        guard input <= limit else {
            return .failure(["\(input) > \(limit)"])
        }
        return .success(input)
    }
}

func divisible( _ by: Int) -> Validator<Int,Int> {
    return Validator<Int,Int> { input in
        guard input % by == 0 else {
            return .failure(["\(input) % \(by) == \(input % by)"])
        }
        return .success(input)
    }
}

let toInt = Validator<String?,Int> { input in
    guard let str = input, !str.isEmpty else {
        return .failure([])
    }
    
    guard let number = Int(str) else {
        return .failure(["<\(str)> is NaN"])
    }
    
    return .success(number)
}

//----------------------------------------------------------------------

struct Account {
    let balance: Int
    let dailyLimit: Int
}

struct ATM {
    let fractions: [Int]
    let available: Int
}

extension Account {
    var amountValidator: Validator<Int,Int> {
        return lessOrEqual(balance) >>> lessOrEqual(dailyLimit)
    }
}

extension Validator {
    static var never: Validator  {
        return Validator { _ in .failure([]) }
    }
}

extension ATM {
    var amountValidator: Validator<Int,Int> {
        return lessOrEqual(available) <&> fractions.map(divisible).reduce(.never, <|>)
    }
}

let myAccount = Account(balance: 10_000, dailyLimit: 5_000)
let myATM = ATM(fractions:[10,20,50], available: 3_000)


func onAmount(_ input: String?) -> Validated<Int> {
    return input |> toInt >>> myAccount.amountValidator <&> myATM.amountValidator
}

//----------------------------------------------------

onAmount(nil)
onAmount("Tim")
onAmount("13")
onAmount("120")
onAmount("4504")

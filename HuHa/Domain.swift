//
//  Domain.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 09/05/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import Foundation

struct Account {
    let balance: Int
    let dailyLimit: Int
}

struct ATM {
    let fractions: [Int]
    let available: Int
}

let myAccount = Account(balance: 10_000, dailyLimit: 5_000)
let myATM = ATM(fractions: [20,50], available: 3_000)

extension Account {
    var validator: Validator<Int, Int> {
        return lessOrEqual(dailyLimit).with("Amount is over your dailyLimit \(dailyLimit)")
            >>> lessOrEqual(balance).with("Your balance is \(balance)")
    }
}

extension Validator where T == Int, U == Int {
    static let valid = Validator<Int, Int> { i in return .success(i) }
    static let invalid = Validator<Int, Int> { _ in return .failure([]) }
}

extension ATM {
    var validator: Validator<Int, Int> {
        let fv = fractions.map(divisible(by:)).reduce(.invalid, >|>)
        let pieces = fractions.map({"\($0)"}).joined(separator: ",")
        
        return lessOrEqual(available).with("Not enough money left")
            >&> fv.with("is not divisible by \(pieces)")
    }
}

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

extension Account {
    var validator: Validator<Int, Int> {
        return lessOrEqual(dailyLimit).with("Amount is over your dailyLimit \(dailyLimit)")
            >>> lessOrEqual(balance).with("Your balance is \(balance)")
    }
}

extension ATM {
    var validator: Validator<Int, Int> {
        let fv = fractions.map(divisible(by:)).reduce(.invalid, <|>)
        let pieces = fractions.map({"\($0)"}).joined(separator: ",")
        
        return lessOrEqual(available).with("Not enough money left")
            <&> fv.with("is not divisible by \(pieces)")
    }
}

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
    let minFraction: Int
    let available: Int
}

let myAccount = Account(balance: 10_000, dailyLimit: 5_000)
let myATM = ATM(minFraction: 20, available: 3_000)
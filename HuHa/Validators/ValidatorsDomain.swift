//
//  ValidatorsDomain.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 12/05/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import Foundation

let toInt = Validator<String?, Int> { input in
    guard let str = input, !str.isEmpty else {
        return .failure([""])
    }
    
    guard let number = Int(str) else {
        return .failure(["<\(str)> is NaN"])
    }
    return .success(number)
}

func lessOrEqual(_ limit: Int) -> Validator<Int, Int> {
    return Validator<Int, Int> { input in
        guard input <= limit else {
            return .failure(["\(input) > \(limit)"])
        }
        return .success(input)
    }
}

func divisible(by divisor: Int) -> Validator<Int, Int> {
    return Validator<Int, Int> { input in
        guard input % divisor == 0 else {
            return .failure(["should me multiple of \(divisor)"])
        }
        return .success(input)
    }
}

//
//  ViewModel.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 09/05/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import Foundation

extension String: Error {}

class ViewModel {
    func onAmount(_ input: String?) -> Result<Int, Error> {
        
        guard let str = input, !str.isEmpty else {
            return .failure("")
        }
        
        guard let number = Int(str) else {
            return .failure("<\(str)> is NaN")
        }
        
        guard number <= myAccount.balance else {
            return .failure("You only have \(myAccount.balance) in your account")
        }
        
        guard number <= myAccount.dailyLimit else {
            return .failure("\(number) is over your daily limit of \(myAccount.dailyLimit)")
        }
        
        guard number <= myATM.available else {
            return .failure("Not enough money left")
        }
        
        guard number % myATM.minFraction == 0 else {
            return .failure("Amount should me multiple of \(myATM.minFraction)")
        }
        
        return .success(number)
    }

}

//
//  ViewModel.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 09/05/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import Foundation

class ViewModel {
    func onAmount(_ input: String?) -> Validated<Int> {
        return input |> toInt >>> myAccount.validator >&> myATM.validator
    }
}

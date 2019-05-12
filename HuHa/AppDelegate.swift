//
//  AppDelegate.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 25/03/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let myAccount = Account(balance: 10_000, dailyLimit: 5_000)
    let myATM = ATM(fractions: [10,20,50], available: 3_000)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let model = ViewModel(account: myAccount, atm: myATM)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController(model: model)
        window?.makeKeyAndVisible()

        return true
    }

}


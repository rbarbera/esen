//
//  ViewController.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 25/03/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import UIKit

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


class ViewController: UIViewController {
    let prompt = UILabel()
    let amount = UITextField()
    let error = UILabel()
    let done = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        let nc = NotificationCenter.default
        nc.addObserver(forName: UITextField.textDidChangeNotification, object: amount, queue: nil) { _ in
            self.onAmount(self.amount.text)
        }
    }
    
    func setupViews() {
        
        let stack = UIStackView(arrangedSubviews: [prompt, amount, error])
        stack.axis = .vertical
        
        view.backgroundColor = .white
        view.addSubview(stack)
        view.addSubview(done)
        
        prompt.font = UIFont.preferredFont(forTextStyle: .title3)
        amount.font = UIFont.preferredFont(forTextStyle: .title1)

        prompt.textColor = .darkGray
        amount.borderStyle = .roundedRect
        amount.keyboardType = .decimalPad
        error.textColor = .red
        error.numberOfLines = 0
        done.setTitleColor(.blue, for: .normal)
        done.setTitleColor(.lightGray, for: .disabled)

        prompt.text = "Amount"
        done.setTitle("Send Money", for: .normal)
        
        [prompt, amount, error, stack, done].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            done.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            done.leftAnchor.constraint(equalTo: stack.leftAnchor),
            done.rightAnchor.constraint(equalTo: stack.rightAnchor)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAmount(amount.text)
    }

    func onAmount(_ input: String?) {
        guard let string = input, !string.isEmpty else {
            error.text = nil
            done.isEnabled = false
            return
        }
        
        guard let value = Int(string) else {
            error.text = "<\(string)> is NaN"
            done.isEnabled = false
            return
        }
        
        guard value > 0 else {
            error.text = "amount should be positive"
            done.isEnabled = false
            return
        }
        
        guard value <= myAccount.balance else {
            error.text = "You only have \(myAccount.balance) in your account"
            done.isEnabled = false
            return
        }

        guard value <= myAccount.dailyLimit else {
            error.text = "You will be over your daily limit"
            done.isEnabled = false
            return
        }
        
        guard value % myATM.minFraction == 0 else {
            error.text = "Amount should be multiple of \(myATM.minFraction)"
            done.isEnabled = false
            return
        }
        
        guard value <= myATM.available else {
            error.text = "Not enough cash on this ATM"
            done.isEnabled = false
            return
        }
        
        error.text = nil
        done.isEnabled = true
    }

}


//
//  ViewController.swift
//  HuHa
//
//  Created by Barbera Cordoba, Rafael on 25/03/2019.
//  Copyright © 2019 Barbera Cordoba, Rafael. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let prompt = UILabel()
    let amount = UITextField()
    let error = UILabel()
    let done = UIButton()
    
    let model = ViewModel()

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
        done.setTitleColor(.white, for: .normal)
        done.setBackgroundImage(UIImage.solid(.blue), for: .normal)
        done.setTitleColor(.white, for: .disabled)
        done.setBackgroundImage(UIImage.solid(.lightGray), for: .disabled)
        done.layer.cornerRadius = 8
        done.clipsToBounds = true

        prompt.text = "Amount"
        done.setTitle("Withdraw", for: .normal)
        
        [prompt, amount, error, stack, done].forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            done.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            done.leftAnchor.constraint(equalTo: stack.leftAnchor),
            done.rightAnchor.constraint(equalTo: stack.rightAnchor),
            done.heightAnchor.constraint(equalToConstant: 42)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAmount(amount.text)
    }

    func onAmount(_ input: String?) {
        switch model.onAmount(input) {
        case .success(let number):
            print("Withdrawal: \(number)")
            error.text = nil
            done.isEnabled = true
        case .failure(let e):
            error.text = e.map({ String(describing: $0) }).joined(separator: "\n")
            done.isEnabled = false
        }
    }
}


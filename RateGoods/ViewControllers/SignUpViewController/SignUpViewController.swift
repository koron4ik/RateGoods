//
//  SignUpViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/25/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import Firebase

protocol SignUpViewControllerCoordinator {
    func showTabsBar()
}

class SignUpViewController: UIViewController {
    
    var coordinator: SignUpViewCoordinator?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.auth = Auth.auth()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let repeatPassword = repeatPasswordTextField.text else {
                return
        }
        
        guard password == repeatPassword else {
            self.view.makeToast("Passwords don't match")
            self.passwordTextField.text?.removeAll()
            self.repeatPasswordTextField.text?.removeAll()
            return
        }
        
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if let user = user {
                self.coordinator?.stop()
            }
            
            if let error = error {
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
}

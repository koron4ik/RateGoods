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
    func dismiss()
}

class SignUpViewController: UIViewController {
    
    weak var coordinator: SignUpViewCoordinator?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        if self.isMovingFromParent {
            self.navigationController?.isNavigationBarHidden = true
            self.coordinator?.dismiss()
        }
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
        
        if password != repeatPassword {
            self.view.makeToast("Passwords don't match")
            self.passwordTextField.text?.removeAll()
            self.repeatPasswordTextField.text?.removeAll()
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if user != nil {
                self.coordinator?.stop()
                return
            }
            
            if let error = error {
                self.view.makeToast(error.localizedDescription)
            }
        }
    }
}

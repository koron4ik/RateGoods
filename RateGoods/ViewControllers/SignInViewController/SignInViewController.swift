//
//  AuthViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/24/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import FirebaseAuth
import Toast_Swift

protocol SignInViewControllerCoordinator: class {
    func showTabsBar()
    func showSignUp()
}

class SignInViewController: UIViewController {
    
    var coordinator: SignInViewControllerCoordinator?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var auth: Auth!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        
        if self.userIsExist() {
            do {
                self.coordinator?.showTabsBar()
                try self.auth.signOut()
            } catch {}
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func userIsExist() -> Bool {
        return auth.currentUser != nil
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
            return
        }
        auth.signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let user = user {
                self?.coordinator?.showTabsBar()
            }
            
            if let error = error {
                self?.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.coordinator?.showSignUp()
    }
}
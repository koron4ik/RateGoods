//
//  AuthViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/24/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
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
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if auth.currentUser != nil {
            self.coordinator?.showTabsBar()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
            return
        }
        
        auth.signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let authResult = authResult {
                self?.coordinator?.showTabsBar()
                DatabaseManager.shared.uploadData(to: DatabaseManager.shared.usersRef.child(authResult.user.uid),
                                                  data: ["email": authResult.user.email])
            }
            
            if let error = error {
                self?.view.makeToast(error.localizedDescription)
            }
        }
    }
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.coordinator?.showSignUp()
    }
}

extension SignInViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.view.makeToast(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        auth.signInAndRetrieveData(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                self?.view.makeToast(error.localizedDescription)
                return
            }
            
            if let authResult = authResult {
                DatabaseManager.shared.uploadData(to: DatabaseManager.shared.usersRef.child(authResult.user.uid), data: ["email": authResult.user.email])
                self?.coordinator?.showTabsBar()
            }
        }
    }
}

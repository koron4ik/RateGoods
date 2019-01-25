//
//  AuthViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/24/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewCoordinator: Coordinator, SignInViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.signInViewController()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        self.rootViewController.pushViewController(self.presentingViewController, animated: false)
    }
    
    func stop() {
        self.rootViewController.popViewController(animated: false)
    }
    
    func showTabsBar() {
        let tabsScreenCoordinator = TabsCoordinator(rootViewController: self.rootViewController)
        tabsScreenCoordinator.start()
    }
    
    func showSignUp() {
        let signUpCoordinator = SignUpViewCoordinator(rootViewController: self.rootViewController)
        signUpCoordinator.start()
    }
}

extension SignInViewCoordinator {
    
    private func signInViewController() -> SignInViewController {
        guard let navigationViewController = R.storyboard.main.signInNavigationController(), let viewController = navigationViewController.topViewController as? SignInViewController else {
            preconditionFailure("Main Storyboard should contain SignInNavigationController and SignInViewController")
        }
        
        viewController.coordinator = self
        
        return viewController
    }
}

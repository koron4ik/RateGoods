//
//  AuthViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/24/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewCoordinator: NSObject, Coordinator, SignInViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.signInViewController()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        self.rootViewController.setViewControllers([presentingViewController], animated: false)
    }
    
    func stop() { }
    
    func showTabsBar() {
        let tabsScreenCoordinator = TabsCoordinator(rootViewController: self.rootViewController)
        self.add(childCoordinator: tabsScreenCoordinator)
        tabsScreenCoordinator.start()
    }
    
    func showSignUp() {
        let signUpCoordinator = SignUpViewCoordinator(rootViewController: self.rootViewController)
        signUpCoordinator.delegate = self
        self.add(childCoordinator: signUpCoordinator)
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

extension SignInViewCoordinator: FinishCoordinatorDelegate {
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator)
    }
}

//
//  SignUpViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/25/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class SignUpViewCoordinator: NSObject, Coordinator, SignUpViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.signInViewController()
    weak var delegate: FinishCoordinatorDelegate?
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        self.rootViewController.pushViewController(self.presentingViewController, animated: true)
    }
    
    func stop() {
        self.rootViewController.popViewController(animated: true)
    }
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
}

extension SignUpViewCoordinator {
    
    private func signInViewController() -> SignUpViewController {
        guard let viewController = R.storyboard.main.signUpViewController() else {
            preconditionFailure("Main Storyboard should contain AuthViewController")
        }
        
        viewController.coordinator = self
        
        return viewController
    }
}

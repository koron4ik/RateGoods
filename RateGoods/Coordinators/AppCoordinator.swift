//
//  AppCoordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var window: UIWindow?
    lazy var rootViewController: UINavigationController = UINavigationController(rootViewController: UIViewController())
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        self.window?.rootViewController = self.rootViewController
        self.window?.makeKeyAndVisible()
        
        self.startTabsCoordinator()
    }
    
    func stop() {
        self.window?.rootViewController = nil
        self.window?.makeKeyAndVisible()
    }
    
    private func startTabsCoordinator() {
        self.rootViewController.navigationBar.isHidden = true
        let tabsScreenCoordinator = TabsCoordinator(rootViewController: self.rootViewController)
        tabsScreenCoordinator.start()
    }
}

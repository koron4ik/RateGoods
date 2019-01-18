//
//  FavouritesViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class FavouritesViewCoordinator: NSObject, Coordinator, FavouritesViewControllerCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start() {
        
    }
    
    func stop() {
        self.rootViewController.dismiss(animated: true)
    }
    
}

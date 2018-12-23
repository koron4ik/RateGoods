//
//  MapViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class MapViewCoordinator: NSObject, Coordinator, MapViewControllerCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    
}

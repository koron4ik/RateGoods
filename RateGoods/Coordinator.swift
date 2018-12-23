//
//  Coordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UINavigationController { get }
    
    func start()
    func stop()
    
}

extension Coordinator {

    public func add(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
    public func remove(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

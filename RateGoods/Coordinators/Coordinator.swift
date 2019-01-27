//
//  Coordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    
    var rootViewController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
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

protocol FinishCoordinatorDelegate: class {
    func finishedFlow(coordinator: Coordinator)
}

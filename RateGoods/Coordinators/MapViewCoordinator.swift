//
//  MapViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps
import FloatingPanel

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
        self.rootViewController.dismiss(animated: true)
    }
    
    func showStoreInfoPanel(floatingPanelController: FloatingPanelController, store: Store) {
        let storeInfoViewCoordinator = StoreInfoViewCoordinator(floatingPanelController: floatingPanelController, store: store)
        storeInfoViewCoordinator.delegate = self
        self.add(childCoordinator: storeInfoViewCoordinator)
        storeInfoViewCoordinator.start()
    }
    
    func showStoreAddingPanel(floatingPanelController: FloatingPanelController, storeLocation: CLLocationCoordinate2D) {
        let storeAddingViewCoordinator = StoreAddingViewCoordinator(floatingPanelController: floatingPanelController, storeLocation: storeLocation)
        storeAddingViewCoordinator.delegate = self
        self.add(childCoordinator: storeAddingViewCoordinator)
        storeAddingViewCoordinator.start()
    }
}

extension MapViewCoordinator: FinishCoordinatorDelegate {
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator)
    }
}

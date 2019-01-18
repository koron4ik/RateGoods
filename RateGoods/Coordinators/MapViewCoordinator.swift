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
    
    func showStore(floatingPanelController: FloatingPanelController, store: Store?, storeLocation: CLLocationCoordinate2D?) {
        if let storeLocation = storeLocation {
            let storeAddingViewCoordinator = StoreAddingViewCoordinator(floatingPanelController: floatingPanelController, storeLocation: storeLocation)
            storeAddingViewCoordinator.start()
        }
        if let store = store {
            let storeInfoViewCoordinator = StoreInfoViewCoordinator(floatingPanelController: floatingPanelController, store: store)
            storeInfoViewCoordinator.start()
        }
    }
}

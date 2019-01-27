//
//  StoreAddingViewCoordiantor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/6/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps
import FloatingPanel

class StoreAddingViewCoordinator: NSObject, Coordinator, StoreAddingViewControllerCoordiantor {
    
    var rootViewController: UINavigationController = UINavigationController()
    var childCoordinators: [Coordinator] = []
    weak var delegate: FinishCoordinatorDelegate?
    private weak var floatingPanelController: FloatingPanelController?
    private var storeLocation: CLLocationCoordinate2D
    
    lazy var presentingViewController: StoreAddingViewController = {
        let storeAddingViewController = StoreAddingViewController()
        storeAddingViewController.coordinator = self
        storeAddingViewController.interactor = StoreAddingViewInteractor(storeLocation: storeLocation)
        return storeAddingViewController
    }()
    
    init(floatingPanelController: FloatingPanelController, storeLocation: CLLocationCoordinate2D) {
        self.floatingPanelController = floatingPanelController
        self.storeLocation = storeLocation
    }
    
    func start() {
        floatingPanelController?.move(to: .full, animated: true)
        floatingPanelController?.set(contentViewController: presentingViewController)
    }
    
    func stop() {
        
    }
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
    
    func storeSaved() {
        if let parent = floatingPanelController?.parent as? MapViewController {
            floatingPanelController?.hide(animated: true, completion: nil)
            
            let marker = GMSMarker(position: storeLocation)
            marker.map = parent.mapView
        }
    }
}

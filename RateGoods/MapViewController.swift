//
//  ViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps
import FloatingPanel

protocol MapViewControllerInteractor: class {
    var stores: [Store] { get }
    
    func setupMapStyle(completion: @escaping (GMSMapStyle?) -> Void)
    func addMarkersToMap(stores: [Store], completion: @escaping (CLLocationCoordinate2D?, String?) -> Void)
    func getStore(with coordinate: CLLocationCoordinate2D) -> Store?
}

protocol MapViewControllerCoordinator: class {
    
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    lazy var floatingPanelController: FloatingPanelController = {
        let floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.addPanel(toParent: self)
        floatingPanelController.isRemovalInteractionEnabled = true
        floatingPanelController.move(to: .hidden, animated: true)
        floatingPanelController.surfaceView.alpha = 0.9
        floatingPanelController.surfaceView.cornerRadius = 16.0
        floatingPanelController.surfaceView.backgroundColor = UIColor.purple
        floatingPanelController.surfaceView.grabberHandle.backgroundColor = UIColor.white
        return floatingPanelController
    }()
    
    var interactor: MapViewControllerInteractor?
    weak var coordinator: MapViewControllerCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactor?.setupMapStyle { [weak self] style in
            self?.mapView.mapStyle = style
        }

        self.mapView.settings.consumesGesturesInView = false
        self.mapView.delegate = self
        
        self.view.makeToastActivity(.center)
        DatabaseManager.shared.loadStores { [weak self] (stores) in
            self?.interactor?.addMarkersToMap(stores: stores, completion: { [weak self] (coordinate, title) in
                if let coordinate = coordinate, let title = title {
                    let marker = GMSMarker(position: coordinate)
                    marker.title = title
                    marker.map = self?.mapView
                }
            })
            self?.view.hideToastActivity()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MyFloatingPanelLayout()
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let storeAddingVC = StoreAddingViewController(storeLocation: coordinate)
        floatingPanelController.move(to: .full, animated: true)
        floatingPanelController.set(contentViewController: storeAddingVC)
        storeAddingVC.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let store = interactor?.getStore(with: marker.position) else { return false }
        
        let storeInfoVC = StoreInfoViewController(store: store)
        floatingPanelController.move(to: .full, animated: true)
        floatingPanelController.set(contentViewController: storeInfoVC)
        
        return true
    }
}

extension MapViewController: StoreAddingViewControllerDelegate {
    
    func storeSaved(with coordinate: CLLocationCoordinate2D) {
        floatingPanelController.move(to: .hidden, animated: true)
        
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }

}

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
import FirebaseAuth

protocol MapViewControllerInteractor: class {
    var stores: [Store] { get set }
    func setupMapStyle(completion: @escaping (_ mapStyle: GMSMapStyle?, _ error: Error?) -> Void)
    func getStore(with coordinate: CLLocationCoordinate2D) -> Store?
}

protocol MapViewControllerCoordinator: class {
    func showStoreInfoPanel(floatingPanelController: FloatingPanelController, store: Store)
    func showStoreAddingPanel(floatingPanelController: FloatingPanelController, storeLocation: CLLocationCoordinate2D)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    weak var floatingPanelController: FloatingPanelController?
    
    var interactor: MapViewInteractor!
    weak var coordinator: MapViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.settings.consumesGesturesInView = false
        self.mapView.delegate = self
        
        self.setupMapstyle()
        self.configureMarkers()
    }
    
    private func setupMapstyle() {
        self.interactor.setupMapStyle { [weak self] style, _ in
            guard let style = style else { return }
            self?.mapView.mapStyle = style
        }
    }
    
    private func configureMarkers() {
        self.view.makeToastActivity(.center)
        DatabaseManager.shared.loadData(from: DatabaseManager.shared.storeRef) { [weak self] (result: Result<[Store]?>) in
            switch result {
            case .success(let stores):
                guard let stores = stores else {
                    self?.view.hideToastActivity()
                    return
                }
                self?.interactor.stores = stores
                self?.interactor.stores.forEach {
                    if let location = $0.location {
                        let marker = GMSMarker(position: location)
                        marker.map = self?.mapView
                    }
                }
            case .failure(let error):
                self?.view.makeToast(error.localizedDescription, duration: 2.0, position: .bottom)
            }
            self?.view.hideToastActivity()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func exitBarButtonItemPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.coordinator?.stop()
        } catch {
            self.view.makeToast(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MyFloatingPanelLayout()
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        floatingPanelController?.removePanelFromParent(animated: false)
        floatingPanelController = createFloatingPanelController()
        
        if let floatingPanelController = floatingPanelController {
            self.coordinator?.showStoreAddingPanel(floatingPanelController: floatingPanelController,
                                                   storeLocation: coordinate)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        floatingPanelController?.removePanelFromParent(animated: false)
        floatingPanelController = createFloatingPanelController()
        
        if let floatingPanelController = floatingPanelController,
            let store = self.interactor.getStore(with: marker.position) {
            self.coordinator?.showStoreInfoPanel(floatingPanelController: floatingPanelController,
                                                 store: store)
        }
        
        return true
    }
}

extension MapViewController {
    
    private func createFloatingPanelController() -> FloatingPanelController {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.addPanel(toParent: self)
        fpc.isRemovalInteractionEnabled = true
        fpc.move(to: .hidden, animated: true)
        fpc.surfaceView.cornerRadius = 16.0
        fpc.surfaceView.backgroundColor = UIColor.purple
        fpc.surfaceView.grabberHandle.backgroundColor = UIColor.white
        
        return fpc
    }
}

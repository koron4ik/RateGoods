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
    var stores: [Store] { get set }
    func setupMapStyle(completion: @escaping (_ mapStyle: GMSMapStyle?, _ error: Error?) -> Void)
    func getStore(with coordinate: CLLocationCoordinate2D) -> Store?
}

protocol MapViewControllerCoordinator: class {
    func showStore(floatingPanelController: FloatingPanelController, store: Store?, storeLocation: CLLocationCoordinate2D?)
    
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    weak var floatingPanelController: FloatingPanelController?
    
    var interactor: MapViewControllerInteractor!
    var coordinator: MapViewControllerCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.interactor.setupMapStyle { [weak self] style, _ in
            guard let style = style else { return }
            self?.mapView.mapStyle = style
        }

        self.mapView.settings.consumesGesturesInView = false
        self.mapView.delegate = self
        
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
                print(error)
                self?.view.makeToast("An unknown error occurred while retrieving data", duration: 2.0, position: .bottom)
            }
            self?.view.hideToastActivity()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createFloatingPanelController() -> FloatingPanelController {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        guard let fpc = floatingPanelController else { return }
        coordinator?.showStore(floatingPanelController: fpc, store: nil, storeLocation: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        floatingPanelController?.removePanelFromParent(animated: false)
        floatingPanelController = createFloatingPanelController()
        
        guard let store = interactor?.getStore(with: marker.position),
            let fpc = floatingPanelController else { return false }
        
        coordinator?.showStore(floatingPanelController: fpc, store: store, storeLocation: nil)
        
        return true
    }
}

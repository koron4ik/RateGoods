//
//  ViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase
import FloatingPanel

protocol MapViewControllerInteractor: class {
    func setupMapStyle(completion: @escaping (GMSMapStyle?) -> Void)
}

protocol MapViewControllerCoordinator: class {
    
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    private var floatingPanelController: FloatingPanelController!
    
    var interactor: MapViewControllerInteractor?
    weak var coordinator: MapViewControllerCoordinator?
    
    var currentStoreLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactor?.setupMapStyle { [weak self] style in
            self?.mapView.mapStyle = style
        }

        self.mapView.settings.consumesGesturesInView = false
        self.mapView.delegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        vc.surfaceView.alpha = 0.9
        vc.surfaceView.cornerRadius = 16.0
        vc.isRemovalInteractionEnabled = true
        return MyFloatingPanelLayout()
    }
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        currentStoreLocation = coordinate

        let marker = GMSMarker(position: coordinate)
        marker.title = "Marker"
        marker.map = mapView
        
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.addPanel(toParent: self)
        floatingPanelController.move(to: .full, animated: true)
        
        let contentVC = R.storyboard.map.panelContentViewController()
        contentVC?.delegate = self
        floatingPanelController.set(contentViewController: contentVC)
        
        //guard let title = marker.title else { return }
        
        //ref.child("coordinates").child(title).setValue(["latitude": coordinate.latitude, "longitude": coordinate.longitude])
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //guard let title = marker.title else { return true }
        
        //ref.child("coordinates").child(title).removeValue()
        marker.map = nil
        
        return true
    }
}

extension MapViewController: PanelContentViewControllerDelegate {
    
    func storeSaving(title: String, imageUrl: String) {
        guard let latitude = currentStoreLocation?.latitude.description,
            let longitude = currentStoreLocation?.longitude.description else {
                return
        }
        
        DatabaseManager.shared.addStore(with: title,
                                        imageUrl: imageUrl,
                                        latitude: latitude,
                                        longitude: longitude)
    }

}

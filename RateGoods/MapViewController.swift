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

protocol MapViewControllerInteractor: class {
    func setupMapStyle(completion: @escaping (GMSMapStyle?) -> Void)
}

protocol MapViewControllerCoordinator: class {
    
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var interactor: MapViewControllerInteractor?
    weak var coordinator: MapViewControllerCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.setupMapStyle { [weak self] style in
            self?.mapView.mapStyle = style
        }
        
        mapView.delegate = self

    }

}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("TAP", coordinate)
        
        let marker = GMSMarker(position: coordinate)
        marker.title = "Marker"
        marker.map = mapView
        
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

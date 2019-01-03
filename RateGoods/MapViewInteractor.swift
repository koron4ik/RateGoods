//
//  MapViewInteractor.swift
//  RateGoods
//
//  Created by Vadim on 12/21/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewInteractor: MapViewControllerInteractor {
    
    var stores = [Store]()
    
    func setupMapStyle(completion: @escaping (GMSMapStyle?) -> Void) {
        DatabaseManager.shared.loadMapStyle { (style) in
            if let mapStyle = self.jsonToString(json: style) {
                do {
                    completion(try GMSMapStyle(jsonString: mapStyle))
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func jsonToString(json: Any) -> String? {
        do {
            let data =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            let convertedString = String(data: data, encoding: .utf8)
            return convertedString
        } catch {
            print(error)
        }
        return nil
    }
    
    func addMarkersToMap(stores: [Store], completion: @escaping (CLLocationCoordinate2D?, String?) -> Void) {
        self.stores = stores
        stores.forEach { (store) in
            guard let latitude = Double(store.latitude),
                let longitude = Double(store.longitude) else {
                    completion(nil, nil)
                    return
            }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            completion(coordinate, store.title)
        }
    }
    
    func getStore(with coordinate: CLLocationCoordinate2D) -> Store? {
        for store in stores {
            guard let latitude = CLLocationDegrees(store.latitude),
                let longitude = CLLocationDegrees(store.longitude) else {
                    continue
            }
            let storeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            if storeCoordinate == coordinate {
                return store
            }
        }
        return nil
    }
}

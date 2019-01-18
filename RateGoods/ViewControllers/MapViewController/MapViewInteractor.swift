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
    
    func setupMapStyle(completion: @escaping (_ mapStyle: GMSMapStyle?, _ error: Error?) -> Void) {
        DatabaseManager.shared.loadMapStyle { result in
            switch result {
            case .success(let value):
                do {
                    guard let value = value else { return }
                    completion(try GMSMapStyle(jsonString: value), nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getStore(with coordinate: CLLocationCoordinate2D) -> Store? {
        for store in stores {
            guard let storeCoordinate = store.location else { return nil }
            if storeCoordinate == coordinate {
                return store
            }
        }
        return nil
    }
}

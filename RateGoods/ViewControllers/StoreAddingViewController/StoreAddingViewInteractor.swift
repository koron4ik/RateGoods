//
//  StoreAddingViewInteractor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/7/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps

class StoreAddingViewInteractor: StoreAddingViewControllerInteractor {
    
    var storeLocation: CLLocationCoordinate2D
    
    init(storeLocation: CLLocationCoordinate2D) {
        self.storeLocation = storeLocation
    }
    
    func saveStore(storeTitle: String, storeImage: UIImage, storeLocation: CLLocationCoordinate2D, completion: @escaping (_ error: Error?) -> Void) {
        
        StorageManager.shared.uploadMedia(path: Constants.Storage.storeImages, image: storeImage) { result in
            switch result {
            case .success(let url):
                guard let url = url else { return }
                let store = Store(title: storeTitle,
                                  imageUrl: url.absoluteString,
                                  location: storeLocation)
                DatabaseManager.shared.uploadData(to: store.ref, store.toAny())
            case .failure(let error):
                print(error)
            }
            completion(nil)
        }
    }
}

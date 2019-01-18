//
//  Store.swift
//  RateGoods
//
//  Created by Vadim on 12/30/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseDatabase

class Store: SnapshotProtocol {
    
    var key: String
    var ref: DatabaseReference
    var title: String?
    var imageUrl: String?
    var location: CLLocationCoordinate2D?
    
    init(title: String, imageUrl: String, location: CLLocationCoordinate2D) {
        self.ref = DatabaseManager.shared.storeRef.childByAutoId()
        self.key = ref.key ?? ""
        self.title = title
        self.imageUrl = imageUrl
        self.location = location
    }
    
    required init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.title = value["title"] as? String
        self.imageUrl = value["imageUrl"] as? String
        
        let latitude = value["latitude"] as? String ?? ""
        let longitude = value["longitude"] as? String ?? ""
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func toAny() -> Any {
        return [
            "title": title,
            "imageUrl": imageUrl,
            "latitude": location?.latitude.description,
            "longitude": location?.longitude.description
        ]
    }
}

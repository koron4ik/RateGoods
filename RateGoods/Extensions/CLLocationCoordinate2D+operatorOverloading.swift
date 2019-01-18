//
//  CLLocationCoordinate2D+operatorOverloading.swift
//  RateGoods
//
//  Created by Vadim on 1/3/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import GoogleMaps

extension CLLocationCoordinate2D {
    
    init?(latitude: String, longitude: String) {
        guard let latitude = CLLocationDegrees(latitude),
            let longitude = CLLocationDegrees(longitude) else {
                return nil
        }
      
        self.init(latitude: latitude, longitude: longitude)
    }
    
    static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        if left.latitude == right.latitude && left.longitude == right.longitude {
            return true
        }
        return false
    }
}

//
//  CLLocationCoordinate2D+operatorOverloading.swift
//  RateGoods
//
//  Created by Vadim on 1/3/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import GoogleMaps

extension CLLocationCoordinate2D {
    
    static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        if left.latitude == right.latitude && left.longitude == right.longitude {
            return true
        }
        return false
    }
}

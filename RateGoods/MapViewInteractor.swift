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
    
}

//
//  Database.swift
//  RateGoods
//
//  Created by Vadim on 12/21/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func loadMapStyle(completionHandler: @escaping (_ value: Any) -> Void) {
        ref.child("mapstyle").observe(.value, with: { (snapshot) in
            guard let style = snapshot.value else { return }
            completionHandler(style)
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
    
    func addStore(with title: String, imageUrl: String, latitude: String, longitude: String) {
        ref.child("stores").childByAutoId().setValue([
            "title": title,
            "imageUrl": imageUrl,
            "latitude": latitude,
            "longitude": longitude
        ])
    }
    
    func loadStores(completionHandler: @escaping (_ value: [Store]) -> Void) {
        ref.observe(.value) { (snapshot) in
            guard let value = snapshot.value else { return }
            //print("stores - \(value)")
            do {
                let item = try FirebaseDecoder().decode(Stores.self, from: value)
                //print(item)
                completionHandler(Array(item.stores.values))
            } catch {
                print(error)
                completionHandler([Store]())
            }
        }
    }
}

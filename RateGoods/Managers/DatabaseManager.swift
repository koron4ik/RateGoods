//
//  Database.swift
//  RateGoods
//
//  Created by Vadim on 12/21/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func loadMapStyle(completionHandler: @escaping (_ value: Any) -> ()) {
        ref.child("mapstyle").observe(.value, with: { (snapshot) in
            guard let style = snapshot.value else { return }
            completionHandler(style)
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
}

//
//  Goods.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/13/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Goods: SnapshotProtocol {
    
    var key: String
    var ref: DatabaseReference
    var title: String?
    var imageUrl: String?
    
    init(storeKey: String, title: String, imageUrl: String) {
        self.ref = DatabaseManager.shared.storeRef.child(storeKey).child(Constants.Database.goods).childByAutoId()
        self.key = ref.key ?? ""
        self.title = title
        self.imageUrl = imageUrl
    }
    
    required init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.imageUrl = value["imageUrl"] as? String
        self.title = value["title"] as? String
    }
    
    func toAny() -> Any {
        return [
            "title": title,
            "imageUrl": imageUrl
        ]
    }
}

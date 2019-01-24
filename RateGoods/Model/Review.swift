//
//  Review.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/13/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Review: SnapshotProtocol {
    
    var key: String
    var ref: DatabaseReference
    var rate: Int?
    var text: String?
    
    init(storeKey: String, goodsKey: String, rate: Int, text: String) {
        let goodsRef = DatabaseManager.shared.storeRef.child(storeKey).child(Constants.Database.goods)
        
        self.ref = goodsRef.child(goodsKey).child(Constants.Database.reviews).childByAutoId()
        self.key = ref.key ?? ""
        self.rate = rate
        self.text = text
    }
    
    required init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.rate = value["rate"] as? Int
        self.text = value["text"] as? String
    }
    
    func toAny() -> Any {
        return [
            "rate": rate as Any,
            "text": text as Any
        ]
    }
}

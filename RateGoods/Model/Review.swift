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
    var rate: Double?
    var text: String?
    var authorEmail: String?
    //var date: Date?
    
    init(goodsRef: DatabaseReference, rate: Double, text: String, authorEmail: String) {
        self.ref = goodsRef.child(Constants.Database.reviews).childByAutoId()
        self.key = ref.key ?? ""
        self.rate = rate
        self.text = text
        self.authorEmail = authorEmail
    }
    
    convenience init(storeKey: String, goodsKey: String, rate: Double, text: String, authorEmail: String) {
        let ref = DatabaseManager.shared.storeRef.child(storeKey).child(Constants.Database.goods).child(goodsKey)
        self.init(goodsRef: ref, rate: rate, text: text, authorEmail: authorEmail)
    }
    
    required init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.rate = value["rate"] as? Double
        self.text = value["text"] as? String
        self.authorEmail = value["author"] as? String
    }
    
    func toAny() -> Any {
        return [
            "rate": rate as Any,
            "text": text as Any,
            "author": authorEmail as Any
        ]
    }
}

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
    var rating: Double?
    var text: String?
    var authorEmail: String?
    //var date: Date?
    
    init(goodsRef: DatabaseReference, rating: Double, text: String, authorEmail: String) {
        self.ref = goodsRef.child(Constants.Database.reviews).childByAutoId()
        self.key = ref.key ?? ""
        self.rating = rating
        self.text = text
        self.authorEmail = authorEmail
    }
    
    convenience init(storeKey: String, goodsKey: String, rating: Double, text: String, authorEmail: String) {
        let ref = DatabaseManager.shared.storeRef.child(storeKey).child(Constants.Database.goods).child(goodsKey)
        self.init(goodsRef: ref, rating: rating, text: text, authorEmail: authorEmail)
    }
    
    required init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any] else { return nil }
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.rating = value["rating"] as? Double
        self.text = value["text"] as? String
        self.authorEmail = value["author"] as? String
    }
    
    func toAny() -> Any {
        return [
            "rating": rating as Any,
            "text": text as Any,
            "author": authorEmail as Any
        ]
    }
}

//
//  Goods.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/13/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

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
    
    func getUserReview(completion: @escaping (Review?) -> Void) {
        let reviewsRef = ref.child(Constants.Database.reviews)
        DatabaseManager.shared.loadDataSingleEvent(from: reviewsRef) { (result: Result<[Review]?>) in
            switch result {
            case .success(let reviews):
                guard let reviews = reviews else {
                    completion(nil)
                    return
                }
                let userReviews = reviews.filter({ $0.authorEmail == Auth.auth().currentUser?.email })
                completion(userReviews.count > 0 ? userReviews[0] : nil)
            default:
                completion(nil)
            }
        }
    }
    
    func toAny() -> Any {
        return [
            "title": title,
            "imageUrl": imageUrl
        ]
    }
}

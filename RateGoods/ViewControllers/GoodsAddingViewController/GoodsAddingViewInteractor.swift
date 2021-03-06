//
//  GoodsAddingViewInteractor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/12/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation
import FirebaseAuth

class GoodsAddingViewInteractor: GoodsAddingViewControllerInteractor {
    
    var store: Store
    
    init(store: Store) {
        self.store = store
    }
    
    func saveGoods(with goodsTitle: String, goodsImageUrl: String, rating: Double, goodsReview: String) {
        let goods = Goods(storeKey: store.key, title: goodsTitle, imageUrl: goodsImageUrl)
        DatabaseManager.shared.uploadData(to: goods.ref, data: goods.toAny()) {
            if rating >= 1 {
                let review = Review(storeKey: self.store.key, goodsKey: goods.key, rating: rating, text: goodsReview, authorEmail: Auth.auth().currentUser?.email ?? "")
                DatabaseManager.shared.uploadData(to: review.ref, data: review.toAny())
            }
        }
    }
}

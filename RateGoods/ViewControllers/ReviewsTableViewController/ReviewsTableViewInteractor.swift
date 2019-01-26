//
//  ReviewsTableViewInteractor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/25/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation

class ReviewsTableViewInteractor: ReviewsTableViewControllerInteractor {
    
    var goods: Goods
    
    init(goods: Goods) {
        self.goods = goods
    }
}

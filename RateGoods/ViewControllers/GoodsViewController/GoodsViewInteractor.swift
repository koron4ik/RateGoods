//
//  GoodsViewInteractor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/10/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class GoodsViewInteractor: GoodsViewControllerInteractor {
    
    var store: Store
    var goods = [Goods]()
    
    init(store: Store) {
        self.store = store
    }
}

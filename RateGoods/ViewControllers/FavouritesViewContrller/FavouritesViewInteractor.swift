//
//  FavouritesViewInteractor.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class FavouritesViewInteractor: FavouritesViewControllerInteractor {
    
    var favouriteGoods = [GoodsCoreData]()
    
    func loadFavouriteGoods() {
        favouriteGoods = CoreDataManager.shared.loadGoods()
    }
    
}

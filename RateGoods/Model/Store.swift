//
//  Store.swift
//  RateGoods
//
//  Created by Vadim on 12/30/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

struct Stores: Decodable {
    var stores: [String: Store]
}

struct Store: Decodable {
    var title: String
    var imageUrl: String
    var latitude: String
    var longitude: String
}

//
//  Result.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/7/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

//
//  String+isEmpty.swift
//  RateGoods
//
//  Created by Vadim on 1/3/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import Foundation

extension String {
    var isEmpty: Bool {
        let splitedStr = self.split(separator: " ")
        if splitedStr.count == 0 {
            return true
        }
        return false
    }
}

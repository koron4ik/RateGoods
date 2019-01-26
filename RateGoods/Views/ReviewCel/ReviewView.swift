//
//  ReviewView.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/25/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import Cosmos

class ReviewView: UIView {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

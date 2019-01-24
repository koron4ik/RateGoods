//
//  AdditionalView.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/11/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import Cosmos

protocol AdditionalViewDelegate: class {
    func addReviewButtonPressed(_ reviewText: String, _ rate: Int)
    func seeAllButtonPressed()
}

class AdditionalView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var rateView: CosmosView!
    
    weak var delegate: AdditionalViewDelegate?
    
    @IBAction func addReviewButtonPressed(_ sender: UIButton) {
        guard let reviewText = reviewTextView.text else { return }

        self.delegate?.addReviewButtonPressed(reviewText, Int(rateView.rating))
    }
    
    @IBAction func seeAllButtonPressed(_ sender: UIButton) {
        
    }
    
}

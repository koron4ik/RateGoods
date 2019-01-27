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
    func addReviewButtonPressed(_ reviewText: String, _ rate: Double)
    func reviewsButtonPressed()
}

class AdditionalView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addReviewButton: UIButton!
    
    weak var delegate: AdditionalViewDelegate?
    
    @IBAction func addReviewButtonPressed(_ sender: UIButton) {
        guard let reviewText = reviewTextView.text else { return }

        self.delegate?.addReviewButtonPressed(reviewText, rateView.rating)
    }
    
    @IBAction func reviewsButtonPressed(_ sender: UIButton) {
        self.delegate?.reviewsButtonPressed()
    }
    
    func configure(with review: Review?) {
        if let review = review {
            reviewTextView.text = review.text
            rateView.rating = review.rate ?? 0.0
            reviewTextView.isUserInteractionEnabled = false
            rateView.isUserInteractionEnabled = false
            addReviewButton.isUserInteractionEnabled = false
            activityIndicator.stopAnimating()
            addReviewButton.backgroundColor = UIColor.lightGray
        } else {
            reviewTextView.isUserInteractionEnabled = true
            rateView.isUserInteractionEnabled = true
            addReviewButton.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
        }
    }
}

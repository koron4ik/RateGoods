//
//  StoreInfoView.swift
//  RateGoods
//
//  Created by Vadim on 12/30/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class StoreInfoPanel: UIView {

    @IBOutlet weak var storeTitleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBAction func viewGoodsButtonPressed(_ sender: UIButton) {
        
    }
    
    func setImage(_ image: UIImage) {
        storeImageView.image = image
    }
    
    func setTitle(with text: String) {
        storeTitleLabel.text = text
    }

    func hideActivityIndicator() {
        activityView.stopAnimating()
    }
}

//
//  StoreInfoView.swift
//  RateGoods
//
//  Created by Vadim on 12/30/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol StoreInfoPanelDelegate: class {
    func showGoods()
}

class StoreInfoPanel: UIView {

    @IBOutlet weak var storeTitleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    weak var delegate: StoreInfoPanelDelegate?
    
    @IBAction func viewGoodsButtonPressed(_ sender: UIButton) {
        delegate?.showGoods()
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

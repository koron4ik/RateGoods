//
//  MainView.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/11/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

protocol MainViewDelegate: class {
    func favouriteButtonPressed()
}

class MainView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    var isFavourite: Bool = false {
        didSet {
            let favouriteButtonImage = UIImage(named: "favourite")
            let unfavouriteButtonImage = UIImage(named: "unfavourite")
            self.favouriteButton.setImage(isFavourite ? favouriteButtonImage : unfavouriteButtonImage,
                                          for: .normal)
        }
    }
    
    weak var delegate: MainViewDelegate?
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        self.delegate?.favouriteButtonPressed()
        isFavourite = !isFavourite
    }
    
}

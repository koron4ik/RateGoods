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
    
    func configure(with store: Store) {
        self.storeTitleLabel.text = store.title
        StorageManager.shared.loadImage(with: store.imageUrl ?? "") { [weak self] result in
            switch result {
            case .success(let image):
                guard let image = image else { return }
                self?.storeImageView.image = image
            case .failure(let error):
                print(error)
                self?.storeImageView.image = UIImage(named: "placeholder_image")
            }
            self?.hideActivityIndicator()
        }
    }

    func hideActivityIndicator() {
        activityView.stopAnimating()
    }
}

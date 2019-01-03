//
//  StoreInfoViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/30/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol StoreInfoViewControllerInteractor: class {
    
}

class StoreInfoViewController: UIViewController {
    
    var storeInfoPanel: StoreInfoPanel!
    
    private var store: Store!
    
    init(store: Store) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.storeInfoPanel = R.nib.storeInfoPanel().instantiate(withOwner: nil, options: nil).first as? StoreInfoPanel
        self.storeInfoPanel.frame = view.frame
        
        self.storeInfoPanel.setTitle(with: store.title)
        StorageManager.shared.loadImage(with: store.imageUrl) { (image) in
            if let image = image {
                self.storeInfoPanel.setImage(image)
            }
            self.storeInfoPanel.hideActivityIndicator()
        }
        
        self.view.addSubview(storeInfoPanel)
    }
}

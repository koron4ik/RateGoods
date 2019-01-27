//
//  StoreInfoViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/30/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol StoreInfoViewControllerInteractor: class {
    var store: Store { get }
}

protocol StoreInfoViewControllerCoordinator: class {
    func showGoods(store: Store) 
}

class StoreInfoViewController: UIViewController {
    
    weak var storeInfoPanel: StoreInfoPanel!
    
    var interactor: StoreInfoViewInteractor!
    weak var coordinator: StoreInfoViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configurePanel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            self.coordinator?.dismiss()
        }
    }
    
    private func configurePanel() {
        self.storeInfoPanel = R.nib.storeInfoPanel.instantiate(withOwner: nil, options: nil).first as? StoreInfoPanel
        self.storeInfoPanel.frame = view.frame
        self.storeInfoPanel.delegate = self
        self.storeInfoPanel.configure(with: self.interactor.store)
        
        self.view.addSubview(storeInfoPanel)
    }
}

extension StoreInfoViewController: StoreInfoPanelDelegate {

    func showGoods() {
        self.coordinator?.showGoods(store: self.interactor.store)
    }
}

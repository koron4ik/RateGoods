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
    
    var storeInfoPanel: StoreInfoPanel!
    
    var interactor: StoreInfoViewInteractor!
    var coordinator: StoreInfoViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureViewController()
        
        StorageManager.shared.loadImage(with: self.interactor.store.imageUrl ?? "") { [weak self] result in
            switch result {
            case .success(let image):
                guard let image = image else { return }
                self?.storeInfoPanel.setImage(image)
            case .failure(let error):
                print(error)
                self?.view.makeToast("An unknown error occurred while retrieving data", duration: 2.0, position: .bottom)
            }
            self?.storeInfoPanel.hideActivityIndicator()
        }
    }
    
    private func configureViewController() {
        self.storeInfoPanel = R.nib.storeInfoPanel.instantiate(withOwner: nil, options: nil).first as? StoreInfoPanel
        self.storeInfoPanel.frame = view.frame
        self.storeInfoPanel.delegate = self
        self.storeInfoPanel.setTitle(with: self.interactor.store.title ?? "")
        self.view.addSubview(storeInfoPanel)
    }
}

extension StoreInfoViewController: StoreInfoPanelDelegate {

    func showGoods() {
        self.coordinator?.showGoods(store: self.interactor.store)
    }
}

//
//  StoreInfoViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/6/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import FloatingPanel

class StoreInfoViewCoordinator: NSObject, StoreInfoViewControllerCoordinator {
    
    private weak var floatingPanelController: FloatingPanelController?
    private var store: Store
    
    lazy var presentingViewController: StoreInfoViewController = {
        let storeInfoViewController = StoreInfoViewController()
        storeInfoViewController.coordinator = self
        storeInfoViewController.interactor = StoreInfoViewInteractor(store: store)
        return storeInfoViewController
    }()
    
    init(floatingPanelController: FloatingPanelController, store: Store) {
        self.floatingPanelController = floatingPanelController
        self.store = store
    }
    
    func start() {
        floatingPanelController?.move(to: .full, animated: true)
        floatingPanelController?.set(contentViewController: presentingViewController)
    }
    
    func stop() {
        
    }
    
    func showGoods(store: Store) {
        guard let navVC = floatingPanelController?.parent?.navigationController else { return }
        let goodsViewCoordinator = GoodsViewCoordinator(rootViewController: navVC, store: store)
        goodsViewCoordinator.start()
    }
    
}

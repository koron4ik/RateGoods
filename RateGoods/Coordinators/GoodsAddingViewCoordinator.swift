//
//  GoodsAddingViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/12/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class GoodsAddingViewCoordinator: NSObject, GoodsAddingViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.createGoodsAddingViewController()
    private var store: Store
    
    init(rootViewController: UINavigationController, store: Store) {
        self.rootViewController = rootViewController
        self.store = store
    }
    
    func start() {
        self.rootViewController.pushViewController(presentingViewController, animated: true)
    }
    
    func stop() {
        self.rootViewController.popViewController(animated: true)
    }
    
    private func createGoodsAddingViewController() -> GoodsAddingViewController {
        guard let viewController = R.storyboard.goods.goodsAddingViewController() else {
            preconditionFailure("Goods Storyboard should contain GoodsViewController")
        }
        
        viewController.interactor = GoodsAddingViewInteractor(store: store)
        viewController.coordinator = self
        
        return viewController
    }
}
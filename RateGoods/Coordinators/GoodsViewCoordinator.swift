//
//  GoodsViewInteractor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/10/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class GoodsViewCoordinator: GoodsViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.createGoodsViewController()
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
    
    func showGoodsAdding(vc: UIViewController, store: Store) {
        guard let navVC = vc.navigationController else { return }
        
        let goodsAddingViewCoordinator = GoodsAddingViewCoordinator(rootViewController: navVC, store: store)
        goodsAddingViewCoordinator.start()
    }
    
    func showAllReviews(vc: UIViewController, goods: Goods) {
        guard let navVC = vc.navigationController else { return }
        
        let reviewsTablewViewCoordinator = ReviewsTableViewCoordinator(rootViewController: navVC, goods: goods)
        reviewsTablewViewCoordinator.start()
    }
}

extension GoodsViewCoordinator {
    
    private func createGoodsViewController() -> GoodsViewController {
        guard let viewController = R.storyboard.goods.goodsViewController() else {
            preconditionFailure("Goods Storyboard should contain GoodsgViewController")
        }
        
        viewController.interactor = GoodsViewInteractor(store: store)
        viewController.coordinator = self
        
        return viewController
    }
}

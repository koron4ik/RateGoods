//
//  GoodsViewInteractor.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/10/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class GoodsViewCoordinator: NSObject, Coordinator, GoodsViewControllerCoordinator {
    
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var delegate: FinishCoordinatorDelegate?
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
    
    func dismiss() {
        self.delegate?.finishedFlow(coordinator: self)
    }
    
    func showGoodsAdding(viewController: UIViewController, store: Store) {
        guard let navVC = viewController.navigationController else { return }
        
        let goodsAddingViewCoordinator = GoodsAddingViewCoordinator(rootViewController: navVC,
                                                                    store: store)
        goodsAddingViewCoordinator.delegate = self
        self.add(childCoordinator: goodsAddingViewCoordinator)
        goodsAddingViewCoordinator.start()
    }
    
    func showAllReviews(viewController: UIViewController, goods: Goods) {
        guard let navVC = viewController.navigationController else { return }
        
        let reviewsTablewViewCoordinator = ReviewsTableViewCoordinator(rootViewController: navVC,
                                                                       goods: goods)
        reviewsTablewViewCoordinator.delegate = self
        self.add(childCoordinator: reviewsTablewViewCoordinator)
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

extension GoodsViewCoordinator: FinishCoordinatorDelegate {
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator)
    }
}

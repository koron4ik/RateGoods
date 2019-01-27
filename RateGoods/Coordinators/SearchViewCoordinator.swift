//
//  SearchViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

class SearchViewCoordinator: NSObject, Coordinator, SearchViewControllerCoordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        super.init()
    }
    
    func start() {
        
    }
    
    func stop() {
        self.rootViewController.dismiss(animated: true)
    }
    
    func showGoodsAdding(viewController: UIViewController, store: Store) {
        guard let navVC = viewController.navigationController else { return }
        
        let goodsAddingViewCoordinator = GoodsAddingViewCoordinator(rootViewController: navVC,
                                                                    store: store)
        //goodsAddingViewCoordinator.delegate = self
        self.add(childCoordinator: goodsAddingViewCoordinator)
        goodsAddingViewCoordinator.start()
    }
    
    func showAllReviews(viewController: UIViewController, goods: Goods) {
        guard let navVC = viewController.navigationController else { return }
        
        let reviewsTablewViewCoordinator = ReviewsTableViewCoordinator(rootViewController: navVC,
                                                                       goods: goods)
        ///reviewsTablewViewCoordinator.delegate = self
        self.add(childCoordinator: reviewsTablewViewCoordinator)
        reviewsTablewViewCoordinator.start()
    }
}

extension SearchViewCoordinator: FinishCoordinatorDelegate {
    func finishedFlow(coordinator: Coordinator) {
        self.remove(childCoordinator: coordinator)
    }
}

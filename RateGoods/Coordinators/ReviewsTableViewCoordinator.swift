//
//  ReviewsTableViewCoordinator.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/25/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class ReviewsTableViewCoordinator: Coordinator, ReviewsTableViewControllerCoordinator {
 
    var rootViewController: UINavigationController
    var childCoordinators: [Coordinator] = []
    lazy var presentingViewController: UIViewController = self.createReviewsTableViewController()
    private var goods: Goods
    
    init(rootViewController: UINavigationController, goods: Goods) {
        self.rootViewController = rootViewController
        self.goods = goods
    }
    
    func start() {
        self.rootViewController.pushViewController(presentingViewController, animated: true)
    }
    
    func stop() {
        self.rootViewController.popViewController(animated: true)
    }
    
}

extension ReviewsTableViewCoordinator {
    
    private func createReviewsTableViewController() -> ReviewsTableViewController {
        guard let viewController = R.storyboard.reviews.reviewsTableViewController() else {
            preconditionFailure("Goods Storyboard should contain ReviewsTableViewController")
        }
        
        viewController.interactor = ReviewsTableViewInteractor(goods: goods)
        viewController.coordinator = self
        
        return viewController
    }
}

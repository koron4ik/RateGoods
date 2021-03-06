//
//  TabsCoordinator.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import Rswift

class TabsCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: UINavigationController
    weak var delegate: FinishCoordinatorDelegate?
    
    lazy var tabBarViewController: UITabBarController = self.createTabsViewController()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.isNavigationBarHidden = true
    }
    
    func start() {
        self.rootViewController.pushViewController(tabBarViewController, animated: false)
    }
    
    func stop() {
        self.rootViewController.popViewController(animated: true)
    }
    
}

extension TabsCoordinator {
 
    private func mapViewController() -> UINavigationController {
        guard let navigationViewController = R.storyboard.map.mapNavigationController(), let viewController = navigationViewController.topViewController as? MapViewController else {
            preconditionFailure("Map Storyboard should contain MapNavigationController and MapViewController")
        }
        
        viewController.interactor = MapViewInteractor()
        let mapViewCoordinator = MapViewCoordinator(rootViewController: rootViewController)
        mapViewCoordinator.delegate = self
        viewController.coordinator = mapViewCoordinator
        self.add(childCoordinator: mapViewCoordinator)
        
        return navigationViewController
    }
    
    private func searchViewController() -> UINavigationController {
        guard let navigationViewController = R.storyboard.search.searchNavigationController(), let viewController = navigationViewController.topViewController as? SearchViewController else {
            preconditionFailure("Search Storyboard should contain SearchNavigationController and SearchViewController")
        }
        
        viewController.interactor = SearchViewInteractor()
        let searchViewCoordinator = SearchViewCoordinator(rootViewController: rootViewController)
        viewController.coordinator = searchViewCoordinator
        self.add(childCoordinator: searchViewCoordinator)
        
        return navigationViewController
    }
    
    private func popularViewController() -> UINavigationController {
        guard let navigationViewController = R.storyboard.popular.popularNavigationController(), let viewController = navigationViewController.topViewController as? PopularViewController else {
            preconditionFailure("Popular Storyboard should contain PopularNavigationController and PopularViewController")
        }
        
        viewController.interactor = PopularViewInteractor()
        let popularViewCoordinator = PopularViewCoordinator(rootViewController: rootViewController)
        viewController.coordinator = popularViewCoordinator
        self.add(childCoordinator: popularViewCoordinator)
        
        return navigationViewController
    }
    
    private func favouritesViewController() -> UINavigationController {
        guard let navigationViewController = R.storyboard.favourites.favouritesNavigationController(), let viewController = navigationViewController.topViewController as? FavouritesViewController else {
            preconditionFailure("Favourites Storyboard should contain FavouritesNavigationController and FavouritesViewController")
        }
        
        viewController.interactor = FavouritesViewInteractor()
        let favouritesViewCoordinator = FavouritesViewCoordinator(rootViewController: rootViewController)
        viewController.coordinator = favouritesViewCoordinator
        self.add(childCoordinator: favouritesViewCoordinator)
        
        return navigationViewController
    }
    
    func createTabsViewController() -> UITabBarController {
        guard let tabBarController = R.storyboard.main.tabsViewController() else {
            preconditionFailure("Main Storyboard should contain TabsViewController")
        }
        tabBarController.viewControllers = [mapViewController(), searchViewController(), favouritesViewController()]
        return tabBarController
    }
}

extension TabsCoordinator: FinishCoordinatorDelegate {
    
    func finishedFlow(coordinator: Coordinator) {
        self.delegate?.finishedFlow(coordinator: self)
        self.stop()
    }
}

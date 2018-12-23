//
//  FavouritesViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol FavouritesViewControllerInteractor: class {

}

protocol FavouritesViewControllerCoordinator: class {
    
}

class FavouritesViewController: UIViewController {
    
    var interactor: FavouritesViewControllerInteractor?
    var coordinator: FavouritesViewControllerCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

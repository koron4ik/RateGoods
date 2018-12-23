//
//  PopularViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol PopularViewControllerInteractor: class {

}

protocol PopularViewControllerCoordinator: class {
    
}

class PopularViewController: UIViewController {
    
    var interactor: PopularViewControllerInteractor?
    var coordinator: PopularViewControllerCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

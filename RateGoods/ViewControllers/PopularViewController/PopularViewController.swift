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
    
    var interactor: PopularViewInteractor!
    weak var coordinator: PopularViewCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
}

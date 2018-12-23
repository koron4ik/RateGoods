//
//  SearchViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol SearchViewControllerInteractor: class {

}

protocol SearchViewControllerCoordinator: class {
    
}

class SearchViewController: UIViewController {
    
    var interactor: SearchViewControllerInteractor?
    var coordinator: SearchViewControllerCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

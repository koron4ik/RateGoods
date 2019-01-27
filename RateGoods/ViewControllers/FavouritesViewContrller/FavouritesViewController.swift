//
//  FavouritesViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/22/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit

protocol FavouritesViewControllerInteractor: class {
    var favouriteGoods: [GoodsCoreData] { get set }
    func loadFavouriteGoods()
}

protocol FavouritesViewControllerCoordinator: class {
    
}

class FavouritesViewController: UIViewController {
    
    var interactor: FavouritesViewInteractor!
    weak var coordinator: FavouritesViewCoordinator?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.interactor.loadFavouriteGoods()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interactor.favouriteGoods.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? GoodsCell else { return UITableViewCell() }
        
        let goods = self.interactor.favouriteGoods[indexPath.row]
        cell.configure(with: goods)
        
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
}

extension FavouritesViewController: GoodsCellDelegate {
    
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath) {
        guard let ref = self.interactor.favouriteGoods[indexPath.row].ref else { return }
        
        if goodsCell.mainView.isFavourite {
            CoreDataManager.shared.deleteGoods(with: ref)
            self.interactor.favouriteGoods.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
}

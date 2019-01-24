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
    
    var interactor: SearchViewControllerInteractor!
    weak var coordinator: SearchViewControllerCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    private var textTimer: Timer?
    private var filteredGoods = [Goods]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//        } else {
//            // Fallback on earlier versions
//            navigationItem.titleView = searchController?.searchBar
//        }
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.configureSearchBar()
        definesPresentationContext = true
    }
    
    private func configureSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.delegate = self
        search.searchBar.placeholder = "Search goods"
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        filteredGoods.removeAll()
        tableView.reloadData()
    }

    @objc private func loadGoodsResults(_ timer: Timer) {
        guard let text = timer.userInfo as? String,
            text.count > 0 else {
                return
        }
        
        self.view.makeToastActivity(.center)
        DatabaseManager.shared.getGoods(with: text) { [weak self] result in
            switch result {
            case .success(let goods):
                guard let goods = goods else {
                    self?.view.hideToastActivity()
                    return
                }
                self?.filteredGoods = goods
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            self?.view.hideToastActivity()
        }
    }
    
    deinit {
        textTimer?.invalidate()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if textTimer != nil {
            textTimer?.invalidate()
            textTimer = nil
        }
        textTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(loadGoodsResults(_:)),
                                         userInfo: searchText,
                                         repeats: false)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredGoods.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? GoodsCell else {
            return UITableViewCell()
        }
        let goods = filteredGoods[indexPath.row]
        
        //        cell.configure(with: goods.title,
        //                       image: nil,
        //                       rate: goods.rate,
        //                       reviews: goods.reviews)
        
        cell.mainView.titleLabel.text = goods.title
        cell.additionalView.titleLabel.text = goods.title
        cell.delegate = self
        cell.indexPath = indexPath
        
        if let imageUrl = goods.imageUrl {
            StorageManager.shared.loadImage(with: imageUrl) { result in
                switch result {
                case .success(let image):
                    guard let image = image else { return }
                    cell.mainView.storeImageView.image = image
                    cell.additionalView.storeImageView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        if CoreDataManager.shared.goodsIsExist(with: goods.ref.description()) {
            cell.mainView.isFavourite = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? GoodsCell else { return }
        
        //cell.isOpen ? cell.close() : cell.open()
        if cell.isOpen {
            cell.close()
        } else {
            cell.open()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}

extension SearchViewController: GoodsCellDelegate {
    
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath) {
        let ref = filteredGoods[indexPath.row].ref.description()
        
        if goodsCell.mainView.isFavourite {
            CoreDataManager.shared.deleteGoods(with: ref)
        } else {
            let title = filteredGoods[indexPath.row].title ?? ""
            let image = goodsCell.mainView.storeImageView.image?.pngData()
            let rate = Float(goodsCell.mainView.rateLabel.text ?? "0.0") ?? 0.0
            let reviews = Int16(goodsCell.mainView.reviewsLabel.text ?? "0") ?? 0
            
            CoreDataManager.shared.saveFavouriteGoods(with: title,
                                                      ref: ref,
                                                      image: image,
                                                      rate: rate,
                                                      reviews: reviews)
        }
    }

    func goodsCell(_ goodsCell: GoodsCell, seeAllReviewsAt indexPath: IndexPath) {
        
    }
    
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rate: Int) {
        
    }
}

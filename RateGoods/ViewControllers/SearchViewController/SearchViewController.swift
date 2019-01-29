//
//  SearchViewController.swift
//  RateGoods
//
//  Created by Vadim on 12/14/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol SearchViewControllerInteractor: class { }

protocol SearchViewControllerCoordinator: class {
    func showGoodsAdding(viewController: UIViewController, store: Store)
    func showAllReviews(viewController: UIViewController, goods: Goods)
}

class SearchViewController: UIViewController {
    
    var interactor: SearchViewInteractor!
    weak var coordinator: SearchViewCoordinator?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    @objc private func loadGoodsResults(_ timer: Timer) {
        guard let text = timer.userInfo as? String, text.count > 0 else {
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
                self?.view.makeToast(error.localizedDescription)
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

extension SearchViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 500
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
        cell.configure(with: goods)
        cell.delegate = self
        cell.additionalView.reviewTextView.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
}

extension SearchViewController: GoodsCellDelegate {
    
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath) {
        let goods = filteredGoods[indexPath.row]
        
        if goodsCell.mainView.isFavourite {
            CoreDataManager.shared.deleteGoods(with: goods.ref.description())
        } else {
            let image = goodsCell.mainView.storeImageView.image?.pngData()
            let rating = Float(goodsCell.mainView.rateLabel.text ?? "0.0") ?? 0.0
            let reviews = Int16(goodsCell.mainView.reviewsLabel.text ?? "0") ?? 0
            
            CoreDataManager.shared.saveFavouriteGoods(with: goods.title ?? "",
                                                      ref: goods.ref.description(),
                                                      image: image,
                                                      rating: rating,
                                                      reviews: reviews)
        }
    }

    func goodsCell(_ goodsCell: GoodsCell, seeAllReviewsAt indexPath: IndexPath) {
        self.coordinator?.showAllReviews(viewController: self,
                                         goods: self.filteredGoods[indexPath.row])
    }
    
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rating: Double) {
        guard rating >= 1 else {
            self.view.makeToast("Enter rating")
            return
        }
        
        let review = Review(goodsRef: filteredGoods[indexPath.row].ref,
                            rating: rating,
                            text: text,
                            authorEmail: Auth.auth().currentUser?.email ?? "")
        DatabaseManager.shared.uploadData(to: review.ref, data: review.toAny())
        goodsCell.additionalView.configure(with: review)
    }
    
    func goodsCell(_ goodsCell: GoodsCell, shouldCloseAt indexPath: IndexPath) {
        goodsCell.close()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] () -> Void in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
            }, completion: nil)
    }
    
    func goodsCell(_ goodsCell: GoodsCell, shouldOpenAt indexPath: IndexPath) {
        goodsCell.open()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { [weak self] () -> Void in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
            }, completion: nil)
    }
}

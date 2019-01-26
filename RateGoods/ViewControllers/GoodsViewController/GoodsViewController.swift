//
//  GoodsViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/6/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import Toast_Swift
import FirebaseAuth

protocol GoodsViewControllerInteractor: class {
    var store: Store { get }
    var goods: [Goods] { get set }
}

protocol GoodsViewControllerCoordinator: class {
    func showGoodsAdding(vc: UIViewController, store: Store)
    func showAllReviews(vc: UIViewController, goods: Goods)
}

class GoodsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    var interactor: GoodsViewInteractor!
    var coordinator: GoodsViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitleLabel.text = self.interactor.store.title ?? "Store"
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.interactor.goods.removeAll()
        self.tableView.reloadData()
        
        self.view.makeToastActivity(.center)
        let goodsRef = interactor.store.ref.child(Constants.Database.goods)
        DatabaseManager.shared.loadData(from: goodsRef) { [weak self] (result: Result<[Goods]?>) in
            switch result {
            case .success(let goods):
                guard let goods = goods else { return }
                self?.interactor.goods = goods
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
                self?.view.makeToast("An unknown error occurred while retrieving data", duration: 2.0, position: .bottom)
            }
            self?.view.hideToastActivity()
        }
    }
    
    @IBAction func addGoodsButtonPressed(_ sender: UIButton) {
        coordinator?.showGoodsAdding(vc: self, store: interactor.store)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.coordinator?.stop()
    }
}

extension GoodsViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension GoodsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interactor.goods.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as? GoodsCell else {
            return UITableViewCell()
        }
        let goods = self.interactor.goods[indexPath.row]
        
//        cell.configure(with: goods.title,
//                       image: nil,
//                       rate: goods.rate,
//                       reviews: goods.reviews)
        
        cell.mainView.titleLabel.text = goods.title
        cell.additionalView.titleLabel.text = goods.title
        cell.delegate = self
        cell.additionalView.reviewTextView.delegate = self
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

extension GoodsViewController: GoodsCellDelegate {
    
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath) {
        let ref = self.interactor.goods[indexPath.row].ref.description()
        
        if goodsCell.mainView.isFavourite {
            CoreDataManager.shared.deleteGoods(with: ref)
        } else {
            let title = self.interactor.goods[indexPath.row].title ?? ""
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
        self.coordinator?.showAllReviews(vc: self, goods: self.interactor.goods[indexPath.row])
    }
    
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rate: Double) {
        guard rate >= 1, !text.isEmpty else {
            return
        }
        
        let review = Review(storeKey: self.interactor.store.key,
                            goodsKey: self.interactor.goods[indexPath.row].key,
                            rate: rate,
                            text: text,
                            authorEmail: Auth.auth().currentUser?.email ?? "")
        DatabaseManager.shared.uploadData(to: review.ref, data: review.toAny())
    }
}

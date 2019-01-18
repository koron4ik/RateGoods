//
//  GoodsViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/6/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit
import Toast_Swift

protocol GoodsViewControllerInteractor: class {
    var store: Store { get }
    var goods: [Goods] { get set }
}

protocol GoodsViewControllerCoordinator: class {
    func showGoodsAdding(vc: UIViewController, store: Store)
}

class GoodsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    
    var interactor: GoodsViewInteractor!
    var coordinator: GoodsViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationTitleLabel.text = self.interactor.store.title ?? "Store"
        self.configureTableView()
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

    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    @IBAction func addGoodsButtonPressed(_ sender: UIButton) {
        coordinator?.showGoodsAdding(vc: self, store: interactor.store)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.coordinator?.stop()
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
        
        cell.mainView.titleLabel.text = self.interactor.goods[indexPath.row].title
        cell.additionalView.titleLabel.text = self.interactor.goods[indexPath.row].title
        
        if let imageUrl = self.interactor.goods[indexPath.row].imageUrl {
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

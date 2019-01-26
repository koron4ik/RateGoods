//
//  ReviewsTableViewController.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/25/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

protocol ReviewsTableViewControllerInteractor {
    var goods: Goods { get }
}

protocol ReviewsTableViewControllerCoordinator {
    
}

class ReviewsTableViewController: UITableViewController {
    
    var interactor: ReviewsTableViewInteractor!
    var coordinator: ReviewsTableViewCoordinator?
    
    private var reviews = [Review]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        self.view.makeToastActivity(.center)
        let reviewsRef = interactor.goods.ref.child(Constants.Database.reviews)
        DatabaseManager.shared.loadData(from: reviewsRef) { [weak self] (result: Result<[Review]?>) in
            switch result {
            case .success(let reviews):
                guard let reviews = reviews else { return }
                self?.reviews = reviews
                self?.tableView.reloadData()
            case .failure(let error):
                self?.view.makeToast(error.localizedDescription, duration: 2.0, position: .bottom)
            }
            self?.view.hideToastActivity()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }

}

extension ReviewsTableViewController {
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ReviewCell else { return UITableViewCell() }
        
        let review = self.reviews[indexPath.row]
        cell.configure(with: review)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

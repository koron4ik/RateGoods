//
//  GoodsCell.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/6/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

protocol GoodsCellDelegate: class {
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath)
    func goodsCell(_ goodsCell: GoodsCell, seeAllReviewsAt indexPath: IndexPath)
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rating: Double)
    func goodsCell(_ goodsCell: GoodsCell, shouldCloseAt indexPath: IndexPath)
    func goodsCell(_ goodsCell: GoodsCell, shouldOpenAt indexPath: IndexPath)
}

extension GoodsCellDelegate {
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath) { }
    func goodsCell(_ goodsCell: GoodsCell, seeAllReviewsAt indexPath: IndexPath) { }
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rating: Double) { }
    func goodsCell(_ goodsCell: GoodsCell, shouldCloseAt indexPath: IndexPath) { }
    func goodsCell(_ goodsCell: GoodsCell, shouldOpenAt indexPath: IndexPath) { }
}

class GoodsCell: UITableViewCell {
    
    enum State {
        case open
        case closed
    }
    
    weak var delegate: GoodsCellDelegate?
    
    var mainView: MainView!
    var additionalView: AdditionalView!
    var indexPath: IndexPath!
    
    private var indent: CGFloat = 8
    private var cornerRadius: CGFloat = 10.0
    private var state = State.closed
    
    var isOpen: Bool {
        return state == State.open ? true : false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        self.mainView = R.nib.mainView.instantiate(withOwner: nil, options: nil).first as? MainView
        self.additionalView = R.nib.additionalView.instantiate(withOwner: nil, options: nil).first as? AdditionalView
        
        mainView.layer.cornerRadius = cornerRadius
        mainView.layer.masksToBounds = true
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.delegate = self
        
        additionalView.layer.cornerRadius = cornerRadius
        additionalView.layer.masksToBounds = true
        additionalView.translatesAutoresizingMaskIntoConstraints = false
        additionalView.delegate = self
        
        selectionStyle = .none
        
        configureDefaultState()
    }
    
    private func configureDefaultState() {
        contentView.addSubview(mainView)
        setupConstraints()
    }
    
    func open() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(additionalView)
        setupConstraints()
        self.state = State.open
    }
    
    func close() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(mainView)
        setupConstraints()
        self.state = State.closed
    }
    
    private func setupConstraints() {
        guard let view = contentView.subviews.first else { return }
        
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indent).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indent).isActive = true
    }
    
    func configure(with goods: Goods) {
        mainView.titleLabel.text = goods.title
        additionalView.titleLabel.text = goods.title
        
        if let imageUrl = goods.imageUrl {
            StorageManager.shared.loadImage(with: imageUrl) { [weak self] result in
                switch result {
                case .success(let image):
                    guard let image = image else { return }
                    self?.mainView.storeImageView.image = image
                    self?.additionalView.storeImageView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        let reviewsRef = goods.ref.child(Constants.Database.reviews)
        DatabaseManager.shared.loadDataSingleEvent(from: reviewsRef) { [weak self] (result: Result<[Review]?>) in
            switch result {
            case .success(let reviews):
                if let reviews = reviews {
                    let reviewsCount = reviews.count
                    let reviewsAverageRating = reviews.compactMap({ $0.rating }).reduce(0, +) / Double(reviewsCount)
                    let roundedAverageRating = Double(round(10 * reviewsAverageRating) / 10)
                    self?.mainView.reviewsLabel.text = String(reviewsCount)
                    self?.mainView.rateLabel.text = String(roundedAverageRating)
                    self?.additionalView.reviewsLabel.text = String(reviewsCount)
                    self?.additionalView.rateLabel.text = String(roundedAverageRating)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        if CoreDataManager.shared.goodsIsExist(with: goods.ref.description()) {
            mainView.isFavourite = true
        }
        
        goods.getUserReview { [weak self] (review) in
            self?.additionalView.configure(with: review)
        }
    }
}

extension GoodsCell: MainViewDelegate {
    
    func mainViewTapped() {
        self.delegate?.goodsCell(self, shouldOpenAt: self.indexPath)
    }
    
    func favouriteButtonPressed() {
        delegate?.goodsCell(self, faviouriteButtonPressedAt: self.indexPath)
    }
}

extension GoodsCell: AdditionalViewDelegate {
    
    func additionalViewTapped() {
        self.delegate?.goodsCell(self, shouldCloseAt: self.indexPath)
    }
    
    func addReviewButtonPressed(_ reviewText: String, _ rating: Double) {
        delegate?.goodsCell(self, addReviewAt: self.indexPath, with: reviewText, rating: rating)
    }
    
    func reviewsButtonPressed() {
        delegate?.goodsCell(self, seeAllReviewsAt: self.indexPath)
    }
}

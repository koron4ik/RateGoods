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
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rate: Int)
}

extension GoodsCellDelegate {
    func goodsCell(_ goodsCell: GoodsCell, faviouriteButtonPressedAt indexPath: IndexPath) { }
    func goodsCell(_ goodsCell: GoodsCell, seeAllReviewsAt indexPath: IndexPath) { }
    func goodsCell(_ goodsCell: GoodsCell, addReviewAt indexPath: IndexPath, with text: String, rate: Int) { }
}

class GoodsCell: UITableViewCell {
    
    enum Height: CGFloat {
        case main = 93
        case additional = 434
    }
    
    enum State {
        case open
        case closed
    }
    
    weak var delegate: GoodsCellDelegate?
    
    var mainView: MainView!
    var additionalView: AdditionalView!
    var indexPath: IndexPath!
    
    var indent: CGFloat = 8
    var cornerRadius: CGFloat = 10.0
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    @IBAction func addReviewButtonPressed(_ sender: UIButton) {
        additionalView.reviewTextView.text.removeAll()
        close()
    }
}

extension GoodsCell: MainViewDelegate {
    
    func favouriteButtonPressed() {
        delegate?.goodsCell(self, faviouriteButtonPressedAt: self.indexPath)
    }
}

extension GoodsCell: AdditionalViewDelegate {
    
    func addReviewButtonPressed(_ reviewText: String, _ rate: Int) {
        delegate?.goodsCell(self, addReviewAt: self.indexPath, with: reviewText, rate: rate)
    }
    
    func seeAllButtonPressed() {
        delegate?.goodsCell(self, seeAllReviewsAt: self.indexPath)
    }
}

extension GoodsCell {
    //configure cell
}

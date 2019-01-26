//
//  ReviewCell.swift
//  RateGoods
//
//  Created by Vadim Koronchik on 1/22/19.
//  Copyright © 2019 Koronchik. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    weak var reviewView: ReviewView!
    
    var indent: CGFloat = 8
    var cornerRadius: CGFloat = 10.0

    override func awakeFromNib() {
        super.awakeFromNib()
       
        commonInit()
    }
    
    func commonInit() {
        self.reviewView = R.nib.reviewView.instantiate(withOwner: nil).first as? ReviewView
        self.reviewView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(reviewView)
        
        selectionStyle = .none
        
        setupConstraints()
    }

    func setupConstraints() {
        guard let view = contentView.subviews.first as? ReviewView else { return }
        
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indent).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -indent).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: indent).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indent).isActive = true
    }
}

//
//  RestaurantDetailCommentCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/11/24.
//

import UIKit

final class RestaurantDetailCommentCell: UITableViewCell {
    
    private let iconImageView: UIImageView = .init()
    private let reviewBackgroundView: UIView = .init()
    private let reviewView: RestaurantDetailReviewView = .init()
    private let lineView: UIView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailReview else { return }
        
        reviewView.update(item: item)
        lineView.isHidden = !item.hasComments
    }
    
    private func setupStyle() {
        iconImageView.image = .iconStar
        reviewBackgroundView.backgroundColor = .gray100
        lineView.backgroundColor = .gray100
    }
    
    private func setupLayout() {
        reviewBackgroundView.addSubview(reviewView, autoLayout: [.fillX(10), .fillY(12)])
        iconImageView.autolayout([.width(14), .height(12)])
        
        let stackView: UIStackView = .init(arrangedSubviews: [iconImageView, reviewBackgroundView])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView, autoLayout: [.fillX(20), .top(0)])
        contentView.addSubview(lineView, autoLayout: [.fillX(20), .topNext(to: stackView, constant: 22), .bottom(0), .height(2)])
    }
}

//
//  RestaurantDetailTierCell.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//
import UIKit

final class RestaurantDetailTierCell: UICollectionViewCell {
    
    private let iconImageView: UIImageView = .init()
    private let label: UILabel = .init()
    
    private var iconImageViewWidthConstraint: NSLayoutConstraint?
    private var iconImageViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailTierInfo) {
        if let cuisineString = item.restaurantCuisine,
           let cuisine = Cuisine(rawValue: cuisineString) {
            iconImageView.image = UIImage(named: cuisine.iconName)
            iconImageViewWidthConstraint?.constant = 29
            iconImageViewHeightConstraint?.constant = 27
        } else {
            iconImageViewWidthConstraint?.constant = 0
        }
        label.text = item.title
        contentView.backgroundColor = item.backgroundColor
        contentView.layoutIfNeeded()
    }
    
    private func setupStyle() {
        iconImageView.contentMode = .scaleAspectFit
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 6
        label.textColor = .white
        label.font = .Pretendard.bold17
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        contentView.addSubview(stackView, autoLayout: [.fillX(10), .fillY(6)])
        
        iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 29)
        iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 27)
        
        iconImageViewWidthConstraint?.isActive = true
        iconImageViewHeightConstraint?.isActive = true
    }
}

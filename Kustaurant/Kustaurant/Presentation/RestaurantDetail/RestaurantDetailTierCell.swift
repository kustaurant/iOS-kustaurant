//
//  RestaurantDetailTierCell.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

extension RestaurantDetailTierCell {
    
    struct Tier {
        let iconImage: UIImage?
        let title: String
        let backgroundHexColor: String
    }
}

final class RestaurantDetailTierCell: UICollectionViewCell {
    
    private let iconImageView: UIImageView = .init()
    private let label: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(tier: Tier) {
        iconImageView.image = tier.iconImage
        label.text = tier.title
        contentView.backgroundColor = .init(named: tier.backgroundHexColor)
    }
    
    private func setupStyle() {
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        addSubview(stackView, autoLayout: [.fillX(10), .fillY(6)])
        iconImageView.autolayout([.width(29), .height(27)])
    }
}

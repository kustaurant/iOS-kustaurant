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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailTierInfo) {
        iconImageView.image = .init(named: item.iconImageName ?? "")
        label.text = item.title
        contentView.backgroundColor = item.backgroundColor
    }
    
    private func setupStyle() {
        iconImageView.contentMode = .scaleAspectFit
        contentView.layer.cornerCurve = .continuous
        contentView.layer.cornerRadius = 6
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        contentView.addSubview(stackView, autoLayout: [.fillX(10), .fillY(6)])
        iconImageView.autolayout([.width(29), .height(27)])
    }
}
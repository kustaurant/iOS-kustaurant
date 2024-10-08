//
//  RestaurantDetailMenuCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/1/24.
//

import UIKit

final class RestaurantDetailMenuCell: UITableViewCell {
    
    private let menuImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let priceLabel: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(image: UIImage, title: String, price: String) {
        menuImageView.image = image
        titleLabel.text = title
        priceLabel.text = price
    }
}

extension RestaurantDetailMenuCell {
    
    private func setupStyle() {
        
    }
    
    private func setupLayout() {
        let labelStackView: UIStackView = .init(arrangedSubviews: [titleLabel, priceLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 6
        labelStackView.distribution = .fillProportionally
        labelStackView.alignment = .leading
        
        let stackView: UIStackView = .init(arrangedSubviews: [menuImageView, labelStackView])
        stackView.axis = .horizontal
        stackView.spacing = 28
        stackView.distribution = .fill
        stackView.alignment = .center
        
        contentView.addSubview(stackView, autoLayout: [.fill(0)])
        menuImageView.autolayout([.width(94), .height(77)])
    }
}

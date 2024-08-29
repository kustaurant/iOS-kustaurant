//
//  SavedRestaurantsTableViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit

final class SavedRestaurantsTableViewCell: UITableViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: SavedRestaurantsTableViewCell.self)

    var model: FavoriteRestaurant? { didSet { bind() }}

    private var restaurantImageView = UIImageView()
    private var tierLabel = UILabel()
    private var restaurantNameLabel = UILabel()
    private var restaurantInfoLabel = UILabel()
    private var iconsStackView = UIStackView()
    private var line = UIView()
    
    // MARK: - Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SavedRestaurantsTableViewCell {
    private func setupUI() {
        contentView.addSubview(restaurantImageView, autoLayout: [.top(7), .leading(20), .width(55), .height(55)])
        contentView.addSubview(tierLabel, autoLayout: [.topEqual(to: restaurantImageView, constant: 0), .leadingEqual(to: restaurantImageView, constant: 0), .width(20), .height(20)])
        
        contentView.addSubview(iconsStackView, autoLayout: [.topEqual(to: restaurantImageView, constant: 8), .trailing(14)])
        contentView.addSubview(restaurantNameLabel, autoLayout: [.topEqual(to: restaurantImageView, constant: 8), .leadingNext(to: restaurantImageView, constant: 16), .trailingNext(to: iconsStackView, constant: 11)])
        contentView.addSubview(restaurantInfoLabel, autoLayout: [.leadingEqual(to: restaurantNameLabel, constant: 0), .trailingEqual(to: restaurantNameLabel, constant: 0), .topNext(to: restaurantNameLabel, constant: 6)])
        contentView.addSubview(line, autoLayout: [.bottom(0), .leading(90), .trailing(20), .height(0.3)])
        
        configureImageView()
        configureLine()
        configureStackView()
        configureRestaurantNameLabel()
        configureRestaurantInfoLabel()
    }
    
    private func configureStackView() {
        iconsStackView.spacing = 3
    }
    
    private func configureRestaurantNameLabel() {
        restaurantNameLabel.font = .Pretendard.medium16
        restaurantNameLabel.textColor = .textBlack
    }
    
    private func configureRestaurantInfoLabel() {
        restaurantInfoLabel.font = .Pretendard.regular12
        restaurantInfoLabel.textColor = .textDarkGray
    }
    
    private func configureImageView() {
        restaurantImageView.layer.cornerRadius = 11
        restaurantImageView.clipsToBounds = true
    }
    
    private func configureLine() {
        line.backgroundColor = .lineGray
    }
}

extension SavedRestaurantsTableViewCell {
    private func bind() {
        bindLabels()
        bindIcons()
        loadImage()
    }
    
    private func bindLabels() {
        if let tier = model?.mainTier {
            tierLabel.setTierStyle(tier: tier)
        }
        restaurantNameLabel.text = model?.restaurantName
        restaurantInfoLabel.text = [model?.restaurantType, model?.restaurantPosition].compactMap({ $0 }).joined(separator: " ㅣ ")
    }
    
    private func bindIcons() {
        iconsStackView.arrangedSubviews.forEach { view in
            iconsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func loadImage() {
        if let urlString = model?.restaurantImgURL,
           let url = URL(string: urlString) {
            ImageCacheManager.shared.loadImage(from: url, targetWidth: 55, defaultImage: UIImage(named: "img_dummy")) { [weak self] image in
                DispatchQueue.main.async {
                    self?.restaurantImageView.image = image
                }
            }
        } else {
            restaurantImageView.image = UIImage(named: "img_dummy")
        }
    }
}

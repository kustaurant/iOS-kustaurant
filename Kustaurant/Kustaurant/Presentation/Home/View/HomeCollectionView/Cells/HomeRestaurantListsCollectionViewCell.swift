//
//  HomeRestaurantListsCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/18/24.
//

import UIKit

final class HomeRestaurantListsCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: HomeRestaurantListsCollectionViewCell.self)
    
    private var restaurantImageView = UIImageView()
    private var tierLabel = UILabel()
    private var restaurantNameLabel = UILabel()
    private var restaurantCuisineAndPositionLabel = UILabel()
    private var partnershipInfoLabel = UILabel()
    private var ratingImageView = UIImageView()
    private var ratingLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeRestaurantListsCollectionViewCell {
    func updateContent(_ data: Restaurant) {
        if let tier = data.mainTier {
            tierLabel.setTierLabel(tier: tier)
        }
        restaurantNameLabel.text = data.restaurantName
        restaurantCuisineAndPositionLabel.text = [data.restaurantCuisine, data.restaurantPosition].compactMap { $0 }.joined(separator: "  |  ")
        partnershipInfoLabel.text = (data.partnershipInfo == nil) ? "제휴 해당사항 없음" : "제휴 : \(data.partnershipInfo!)"
        ratingLabel.text = "4.5"
        
        if let urlString = data.restaurantImgUrl,
           let url = URL(string: urlString) {
            ImageCacheManager.shared.loadImage(from: url, targetWidth: bounds.width) { image in
                DispatchQueue.main.async {
                    self.restaurantImageView.image = image ?? UIImage(named: "img_dummy")
                }
            }
        }
    }
}

extension HomeRestaurantListsCollectionViewCell {
    private func setupUI() {
        addSubviews()
        setupConstraint()
        
        setupImageView()
        setupLabels()
    }
    
    private func addSubviews() {
        [restaurantImageView, tierLabel, restaurantNameLabel, restaurantCuisineAndPositionLabel, partnershipInfoLabel, ratingLabel,  ratingImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 128),
            restaurantImageView.widthAnchor.constraint(equalToConstant: bounds.width),
            
            tierLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            tierLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 11),
            tierLabel.widthAnchor.constraint(equalToConstant: 23),
            tierLabel.heightAnchor.constraint(equalToConstant: 25),
            
            ratingLabel.topAnchor.constraint(equalTo: restaurantImageView.bottomAnchor, constant: 8),
            ratingLabel.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: 16),
            
            ratingImageView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant: -2),
            ratingImageView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            
            restaurantCuisineAndPositionLabel.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            restaurantCuisineAndPositionLabel.trailingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            restaurantCuisineAndPositionLabel.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),

            restaurantNameLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 4),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor),

            partnershipInfoLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 8),
            partnershipInfoLabel.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            partnershipInfoLabel.trailingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor)
        ])
    }
    
    private func setupImageView() {
        restaurantImageView.layer.cornerRadius = 11
        restaurantImageView.clipsToBounds = true
        
        ratingImageView.image = UIImage(named: "icon_star_rating")
    }
    
    private func setupLabels() {
        restaurantCuisineAndPositionLabel.font = .pretendard(size: 12, weight: .regular)
        restaurantCuisineAndPositionLabel.textColor = .textBlack
        
        ratingLabel.font = .pretendard(size: 12, weight: .regular)
        ratingLabel.textColor = .ratingText
        
        restaurantNameLabel.font = .pretendard(size: 15, weight: .medium)
        restaurantNameLabel.textColor = .textBlack
        
        partnershipInfoLabel.font = .pretendard(size: 13, weight: .regular)
        partnershipInfoLabel.textColor = .textLightGray
    }
}

//
//  HomeRestaurantsCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/18/24.
//

import UIKit

final class HomeRestaurantsCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: HomeRestaurantsCollectionViewCell.self)
    var model: Restaurant? { didSet { bind() }}
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

extension HomeRestaurantsCollectionViewCell {
    private func bind() {
        guard let restaurant = model else { return }
        if let tier = restaurant.mainTier {
            tierLabel.setTierStyle(tier: tier)
        }
        restaurantNameLabel.text = restaurant.restaurantName
        restaurantCuisineAndPositionLabel.text = [restaurant.restaurantCuisine, restaurant.restaurantPosition].compactMap { $0 }.joined(separator: "  |  ")
        partnershipInfoLabel.text = (restaurant.partnershipInfo == nil) ? "제휴 해당사항 없음" : "제휴 : \(restaurant.partnershipInfo!)"
        ratingLabel.text = String(describing: restaurant.restaurantScore ?? 0)
        
        loadImage(restaurant.restaurantImgUrl)
    }
    
    private func loadImage(_ urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString)
        else {
            return
        }
        Task {
            let image = await ImageCacheManager.shared.loadImage(
                from: url,
                targetSize: bounds.size,
                defaultImage: UIImage(named: "img_dummy")
            )
            await MainActor.run {
                restaurantImageView.image = image
            }
        }
    }
}

extension HomeRestaurantsCollectionViewCell {
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
        
        restaurantCuisineAndPositionLabel.font = .Pretendard.regular12
        restaurantCuisineAndPositionLabel.textColor = .textBlack
        
        ratingLabel.font = .Pretendard.regular12
        ratingLabel.textColor = .ratingText
        
        restaurantNameLabel.font = .Pretendard.medium15
        restaurantNameLabel.textColor = .textBlack
        
        partnershipInfoLabel.font = .Pretendard.regular13
        partnershipInfoLabel.textColor = .textLightGray
    }
}

//
//  TierMapBottomSheetView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/22/24.
//

import UIKit

final class TierMapBottomSheetView: UIView {
    private var restaurant: Restaurant?
    private let imageView = UIImageView()
    private var evaluatedImageView = UIImageView()
    private var favoriteImageView = UIImageView()
    private let iconStackView = UIStackView()
    private var tierLabel = UILabel()
    private let nameLabel = UILabel()
    private let infoLabel = UILabel()
    private let partnershipLabel = UILabel()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierMapBottomSheetView {
    func update(_ restaurant: Restaurant) {
        self.restaurant = restaurant
        loadImage()
        updateIcons()
        updateTier()
        nameLabel.text = restaurant.restaurantName ?? ""
        updateInfo()
        partnershipLabel.text = restaurant.partnershipInfo ?? "제휴 해당 사항 없음"
    }
}

extension TierMapBottomSheetView {
    private func setup() {
        backgroundColor = .white
        addSubview(imageView, autoLayout: [.top(21), .leading(19), .width(73), .height(73)])
        iconStackView.addArrangedSubview(favoriteImageView)
        iconStackView.addArrangedSubview(evaluatedImageView)
        addSubview(iconStackView, autoLayout: [.bottomEqual(to: imageView, constant: 0), .leadingEqual(to: imageView, constant: 0)])
        addSubview(tierLabel, autoLayout: [.top(21), .trailing(25), .width(30), .height(30)])
        addSubview(nameLabel, autoLayout: [.top(23), .leadingNext(to: imageView, constant: 23), .trailingNext(to: tierLabel, constant: 20)])
        addSubview(infoLabel, autoLayout: [.topNext(to: nameLabel, constant: 8.5), .leadingNext(to: imageView, constant: 23), .trailingNext(to: tierLabel, constant: 20)])
        addSubview(partnershipLabel, autoLayout: [.topNext(to: infoLabel, constant: 10), .leadingNext(to: imageView, constant: 23), .trailingNext(to: tierLabel, constant: 20)])
        
        configureImageView()
        configureStatusImageView()
        configureTierLabel()
        configureNameLabel()
        configureInfoLabel()
        configurePartnershipLabel()
    }
    
    private func configureImageView() {
        imageView.layer.cornerRadius = 11
        imageView.clipsToBounds = true
    }
    
    private func configureStatusImageView() {
        favoriteImageView.image = UIImage(named: "icon_favorite")
        evaluatedImageView.image = UIImage(named: "icon_check")
        favoriteImageView.autolayout([.width(19), .height(19)])
        evaluatedImageView.autolayout([.width(19), .height(19)])
    }
    
    private func configureTierLabel() {
        tierLabel.font = .Pretendard.bold23
        tierLabel.textAlignment = .center
        tierLabel.textColor = .white
        tierLabel.layer.cornerRadius = 8
        tierLabel.clipsToBounds = true
    }
    
    private func configureNameLabel() {
        nameLabel.font = .Pretendard.semiBold16
        nameLabel.textColor = .textBlack
    }
    
    private func configureInfoLabel() {
        infoLabel.font = .Pretendard.regular12
        infoLabel.textColor = .textDarkGray
    }
    
    private func configurePartnershipLabel() {
        partnershipLabel.font = .Pretendard.regular10
        partnershipLabel.textColor = .gray300
    }
    
    private func updateInfo() {
        guard let restaurant = restaurant else { return }
        let situationList = restaurant.situationList?.compactMap({ $0 }).joined(separator: ", ")
        infoLabel.text = [restaurant.restaurantCuisine, restaurant.restaurantPosition, situationList].compactMap({ $0 }).joined(separator: " ㅣ ")
    }
    
    private func updateTier() {
        guard let tier = restaurant?.mainTier else { return }
        tierLabel.text = (tier != .unowned) ? "\(tier.rawValue)" : "-"
        tierLabel.backgroundColor = tier.backgroundColor()
    }
    
    private func updateIcons() {
        guard let restaurant = restaurant else { return }
        iconStackView.arrangedSubviews.forEach { view in
            iconStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        let isFavorite = [true, false].randomElement()!
        let isEvaluated = restaurant.isEvaluated ?? false

        if isFavorite {
            iconStackView.addArrangedSubview(favoriteImageView)
        }
        if isEvaluated {
            iconStackView.addArrangedSubview(evaluatedImageView)
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: restaurant?.restaurantImgUrl ?? "") else { return }
        ImageCacheManager.shared.loadImage(
            from: url,
            targetWidth: 73,
            defaultImage: UIImage(named: "img_dummy")
        ) { [weak self] image in
            Task {
                await MainActor.run {
                    self?.imageView.image = image
                }
            }
        }
    }
}

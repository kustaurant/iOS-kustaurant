//
//  TierListTableViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierListTableViewCell: UITableViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: TierListTableViewCell.self)

    var model: Restaurant? { didSet { bind() }}

    private var restaurantImageView = UIImageView()
    private var tierLabel = UILabel()
    private var indexLabel = UILabel()
    private var restaurantNameLabel = UILabel()
    private var restaurantInfoLabel = UILabel()
    private var iconsStackView = UIStackView()
    private var evaluatedImageView = UIImageView()
    private var favoriteImageView = UIImageView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImageView.image = nil
    }
}

extension TierListTableViewCell {
    private func setupUI() {
        contentView.addSubview(restaurantImageView, autoLayout: [.top(7), .leading(20), .width(55), .height(55)])
        contentView.addSubview(tierLabel, autoLayout: [.topEqual(to: restaurantImageView, constant: 0), .leadingEqual(to: restaurantImageView, constant: 0), .width(20), .height(20)])
        
        iconsStackView.addArrangedSubview(favoriteImageView)
        iconsStackView.addArrangedSubview(evaluatedImageView)
        contentView.addSubview(iconsStackView, autoLayout: [.topEqual(to: restaurantImageView, constant: 8), .trailing(14)])
        contentView.addSubview(indexLabel, autoLayout: [.topEqual(to: restaurantImageView, constant: 8), .leadingNext(to: restaurantImageView, constant: 18)])
        contentView.addSubview(restaurantNameLabel, autoLayout: [.topEqual(to: restaurantImageView, constant: 8), .leadingNext(to: indexLabel, constant: 5), .trailingNext(to: iconsStackView, constant: 11)])
        contentView.addSubview(restaurantInfoLabel, autoLayout: [.leadingEqual(to: restaurantNameLabel, constant: 0), .trailingEqual(to: restaurantNameLabel, constant: 0), .topNext(to: restaurantNameLabel, constant: 6)])
        contentView.addSubview(line, autoLayout: [.bottom(0), .leading(90), .trailing(20), .height(0.3)])
        
        configureImageView()
        configureLine()
        configureIndexLabel()
        configureStackView()
        configureStatusImageView()
        configureRestaurantNameLabel()
        configureRestaurantInfoLabel()
    }
    
    private func configureStackView() {
        iconsStackView.spacing = 3
    }
    
    private func configureStatusImageView() {
        favoriteImageView.image = UIImage(named: "icon_favorite")
        evaluatedImageView.image = UIImage(named: "icon_check")
        favoriteImageView.autolayout([.width(19), .height(19)])
        evaluatedImageView.autolayout([.width(19), .height(19)])
    }
    
    private func configureIndexLabel() {
        indexLabel.font = .Pretendard.semiBold16
        indexLabel.textColor = .textGreen
        indexLabel.setContentHuggingPriority(.required, for: .horizontal)
        indexLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
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

extension TierListTableViewCell {
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
        restaurantInfoLabel.text = [model?.restaurantCuisine, model?.restaurantPosition].compactMap({ $0 }).joined(separator: " ㅣ ")
        indexLabel.text = "\(model?.index ?? 0)."
    }
    
    private func bindIcons() {
        iconsStackView.arrangedSubviews.forEach { view in
            iconsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        let isFavorite = model?.isFavorite ?? false
        let isEvaluated = model?.isEvaluated ?? false

        if isFavorite {
            iconsStackView.addArrangedSubview(favoriteImageView)
        }
        if isEvaluated {
            iconsStackView.addArrangedSubview(evaluatedImageView)
        }
    }
    
    private func loadImage() {
        guard let urlString = model?.restaurantImgUrl,
              let url = URL(string: urlString)
        else { return }
        Task {
            let image = await ImageCacheManager.shared.loadImage(
                from: url,
                targetSize: CGSize(width: 55, height: 55),
                defaultImage: UIImage(named: "img_dummy")
            )
            await MainActor.run {
                restaurantImageView.image = image
            }
        }
    }

}

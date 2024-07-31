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
    private var evaluatedImageView = CustomIconImageView(type: .check, size: CGSize(width: 19, height: 19))
    private var favoriteImageView = CustomIconImageView(type: .favorite, size: CGSize(width: 19, height: 19))
    private var line = UIView()
    
    private var evaluatedTrailingConstraint: NSLayoutConstraint!
    private var favoriteTrailingConstraint: NSLayoutConstraint!
    private var evaluatedLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
}

extension TierListTableViewCell {
    private func setupUI() {
        addSubviews()
        setupConstraints()
        setupLabels()
        setupImageView()
        setupLine()
    }
    
    private func addSubviews() {
        [restaurantImageView, tierLabel, indexLabel, restaurantNameLabel, restaurantInfoLabel, favoriteImageView, evaluatedImageView, line].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        setupImageViewConstraints()
        setupLabelConstraints()
        setupIconConstraints()
        setupLineConstraint()
    }
    
    private func setupImageView() {
        restaurantImageView.layer.cornerRadius = 11
        restaurantImageView.clipsToBounds = true
    }
    
    private func setupLabels() {
        indexLabel.font = .pretendard(size: 16, weight: .semibold)
        indexLabel.textColor = .textGreen
        restaurantNameLabel.font = .pretendard(size: 16, weight: .medium)
        restaurantNameLabel.textColor = .textBlack
        restaurantInfoLabel.font = .pretendard(size: 12, weight: .regular)
        restaurantInfoLabel.textColor = .textDarkGray
    }
    
    private func setupLine() {
        line.backgroundColor = .lineGray
    }
    
    private func setupImageViewConstraints() {
        NSLayoutConstraint.activate([
            restaurantImageView.widthAnchor.constraint(equalToConstant: 55),
            restaurantImageView.heightAnchor.constraint(equalToConstant: 55),
            restaurantImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            restaurantImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            tierLabel.topAnchor.constraint(equalTo: restaurantImageView.topAnchor),
            tierLabel.leadingAnchor.constraint(equalTo: restaurantImageView.leadingAnchor),
            tierLabel.widthAnchor.constraint(equalToConstant: 20),
            tierLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupLabelConstraints() {
        NSLayoutConstraint.activate([
            indexLabel.topAnchor.constraint(equalTo: restaurantImageView.topAnchor, constant: 7),
            indexLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 17),
            
            restaurantNameLabel.leadingAnchor.constraint(equalTo: restaurantImageView.trailingAnchor, constant: 46),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -65),
            restaurantNameLabel.centerYAnchor.constraint(equalTo: indexLabel.centerYAnchor),
            
            restaurantInfoLabel.leadingAnchor.constraint(equalTo: restaurantNameLabel.leadingAnchor),
            restaurantInfoLabel.trailingAnchor.constraint(equalTo: restaurantNameLabel.trailingAnchor),
            restaurantInfoLabel.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 6)
        ])
    }
    
    private func setupIconConstraints() {
        favoriteTrailingConstraint = favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        evaluatedTrailingConstraint = evaluatedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -13)
        evaluatedLeadingConstraint = evaluatedImageView.trailingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor, constant: -3)
        
        NSLayoutConstraint.activate([
            favoriteImageView.centerYAnchor.constraint(equalTo: indexLabel.centerYAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 19),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 19),
            
            evaluatedImageView.centerYAnchor.constraint(equalTo: favoriteImageView.centerYAnchor),
            evaluatedImageView.widthAnchor.constraint(equalToConstant: 19),
            evaluatedImageView.heightAnchor.constraint(equalToConstant: 19)
        ])
    }
    
    private func setupLineConstraint() {
        NSLayoutConstraint.activate([
            line.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 90),
            line.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            line.heightAnchor.constraint(equalToConstant: 0.3)
        ])
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
        indexLabel.text = "\(model?.index ?? 0)"
    }
    
    private func bindIcons() {
        let isFavorite = model?.isFavorite ?? false
        let isEvaluated = model?.isEvaluated ?? false
        favoriteImageView.isHidden = !isFavorite
        evaluatedImageView.isHidden = !isEvaluated
        
        if isFavorite {
            NSLayoutConstraint.deactivate([evaluatedTrailingConstraint])
            NSLayoutConstraint.activate([favoriteTrailingConstraint, evaluatedLeadingConstraint])
        } else {
            NSLayoutConstraint.deactivate([favoriteTrailingConstraint, evaluatedLeadingConstraint])
            NSLayoutConstraint.activate([evaluatedTrailingConstraint])
        }
    }
    
    private func loadImage() {
        if let urlString = model?.restaurantImgUrl,
           let url = URL(string: urlString) {
            ImageCacheManager.shared.loadImage(from: url, targetWidth: 55) { [weak self] image in
                DispatchQueue.main.async {
                    self?.restaurantImageView.image = image ?? UIImage(named: "img_dummy")
                }
            }
        }
    }
}

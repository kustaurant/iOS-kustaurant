//
//  HomeCategoriesCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 8/4/24.
//

import UIKit

final class HomeCategoriesCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: HomeCategoriesCollectionViewCell.self)
    var cuisine: Cuisine? {
        didSet { bind() }
    }
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCategoriesCollectionViewCell {
    private func bind() {
        guard let cuisine = cuisine else { return }
        iconImageView.image = UIImage(named: cuisine.iconName)?.withRenderingMode(.alwaysOriginal)
        titleLabel.text = cuisine.rawValue
    }
}

extension HomeCategoriesCollectionViewCell {
    private func setup() {
        addSubviews()
        setupContent()
        setupTitleLabel()
    }
    
    private func addSubviews() {
        contentView.addSubview(iconImageView, autoLayout: [.centerX(0), .top(7)])
        contentView.addSubview(titleLabel, autoLayout: [.centerX(0), .bottom(7.5)])
    }
    
    private func setupContent() {
        contentView.backgroundColor = .homeCategoryBackground
        contentView.layer.cornerRadius = 15
    }
    
    private func setupTitleLabel() {
        titleLabel.textColor = .Sementic.gray800
        titleLabel.font = .Pretendard.medium11
    }
}

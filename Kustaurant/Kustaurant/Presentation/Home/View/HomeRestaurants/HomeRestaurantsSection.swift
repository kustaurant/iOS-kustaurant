//
//  HomeRestaurantsSection.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

final class HomeRestaurantsSection: UITableViewCell, ReusableCell {
    static let reuseIdentifier = String(describing: HomeRestaurantsSection.self)
    static let sectionHeight: CGFloat = 261.0
    static let sectionBottomInset: CGFloat = 53.0
    var sectionType: HomeSection? {
        didSet { bind() }
    }
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    let collectionView = HomeRestaurantsCollectionView()

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

extension HomeRestaurantsSection {
    private func bind() {
        titleLabel.text = sectionType?.titleText()
        subtitleLabel.text = sectionType?.subTitleText()
    }
}

extension HomeRestaurantsSection {
    private func setupUI() {
        addSubviews()
        setupConstraint()
        setupLabels()
    }
    
    private func addSubviews() {
        [titleLabel, subtitleLabel, collectionView].forEach({
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 16),
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupLabels() {
        titleLabel.textColor = .textBlack
        titleLabel.font = .Pretendard.bold20
        subtitleLabel.textColor = .textLightGray
        subtitleLabel.font = .Pretendard.regular13
    }
}

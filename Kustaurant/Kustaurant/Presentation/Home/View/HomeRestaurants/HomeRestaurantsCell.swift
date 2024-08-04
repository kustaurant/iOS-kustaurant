//
//  HomeRestaurantsCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

final class HomeRestaurantsCell: UICollectionViewCell, ReusableCell {
    static let reuseIdentifier = String(describing: HomeRestaurantsCell.self)
    var sectionType: HomeSection? {
        didSet { updateContent() }
    }
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    let moreButton = UIButton()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HomeRestaurantsListCell.self, forCellWithReuseIdentifier: HomeRestaurantsListCell.reuseIdentifier)
        return collectionView
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeRestaurantsCell {
    func updateAndReload(section: HomeSection) {
        sectionType = section
        collectionView.reloadData()
    }
    
    private func updateContent() {
        titleLabel.text = sectionType?.titleText()
        subtitleLabel.text = sectionType?.subTitleText()
    }
}

extension HomeRestaurantsCell {
    private func setupUI() {
        addSubviews()
        setupConstraint()
        setupLabels()
        setupButton()
    }
    
    private func addSubviews() {
        [titleLabel, subtitleLabel, moreButton, collectionView].forEach({
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 34),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            moreButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
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
    
    private func setupButton() {
        var config = UIButton.Configuration.plain()
        let attributedString = NSAttributedString(string: "더보기", attributes: [
            .font: UIFont.Pretendard.medium11,
            .foregroundColor: UIColor.textDarkGray
        ])
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
        moreButton.configuration = config
        moreButton.setAttributedTitle(attributedString, for: .normal)
    }
}

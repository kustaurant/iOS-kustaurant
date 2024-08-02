//
//  HomeMainCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

final class HomeMainCollectionViewCell: UICollectionViewCell, ReusableCell {
    static let reuseIdentifier = String(describing: HomeMainCollectionViewCell.self)
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
        collectionView.register(HomeRestaurantListsCollectionViewCell.self, forCellWithReuseIdentifier: HomeRestaurantListsCollectionViewCell.reuseIdentifier)
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

extension HomeMainCollectionViewCell {
    func updateAndReload(section: HomeSection) {
        sectionType = section
        collectionView.reloadData()
    }
    
    private func updateContent() {
        switch sectionType {
        case .topRestaurants:
            titleLabel.text = "인증된 건대 TOP 맛집"
            subtitleLabel.text = "가장 높은 평가를 받은 맛집을 알려드립니다."
        case .forMeRestaurants:
            titleLabel.text = "나를 위한 건대 맛집"
            subtitleLabel.text = "즐겨찾기를 바탕으로 다른 맛집을 추천해 드립니다."
        default: return
        }
    }
}

extension HomeMainCollectionViewCell {
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

//
//  HomeMainCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

final class HomeMainCollectionViewCell: UICollectionViewCell, ReusableCell {
    static let reuseIdentifier = String(describing: HomeMainCollectionViewCell.self)
    var sectionType: HomeSection?
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
    private func setupUI() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        [collectionView].forEach({
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

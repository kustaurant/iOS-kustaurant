//
//  TierCategoryView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/31/24.
//

import UIKit

final class TierCategoryView: UIView {
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TierCategorySectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TierCategorySectionHeaderView.reuseIdentifier)
        collectionView.register(TierListCategoryCollectionViewCell.self, forCellWithReuseIdentifier: TierListCategoryCollectionViewCell.reuseIdentifier)
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

extension TierCategoryView {
    private func setupUI() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        [categoriesCollectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

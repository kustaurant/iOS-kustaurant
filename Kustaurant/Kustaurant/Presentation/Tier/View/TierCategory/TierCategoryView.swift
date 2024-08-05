//
//  TierCategoryView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/31/24.
//

import UIKit

final class TierCategoryView: UIView {
    lazy var categoriesCollectionView: UICollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize // 셀 크기를 자동으로 조정
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TierCategorySectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TierCategorySectionHeaderView.reuseIdentifier)
        collectionView.register(TierListCategoryCollectionViewCell.self, forCellWithReuseIdentifier: TierListCategoryCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    let actionButton = KuSubmitButton()
    
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
        backgroundColor = .white
        addSubviews()
        setupConstraint()
        setupActionButton()
    }
    
    private func addSubviews() {
        [categoriesCollectionView, actionButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            actionButton.heightAnchor.constraint(equalToConstant: 52),
            categoriesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: 10)
        ])
    }
    
    private func setupActionButton() {
        actionButton.buttonTitle = "적용하기"
    }

}

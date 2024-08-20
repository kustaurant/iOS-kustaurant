//
//  TierTopCategoriesCollectionView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/18/24.
//

import UIKit

final class TierTopCategoriesCollectionView: UICollectionView {
    private let layout: UICollectionViewFlowLayout = .init()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 7

        registerCell(ofType: TierCategoryCollectionViewCell.self, withReuseIdentifier: TierCategoryCollectionViewCell.reuseIdentifier)
    }
}

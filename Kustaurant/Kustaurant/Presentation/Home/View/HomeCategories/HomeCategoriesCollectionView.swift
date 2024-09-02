//
//  HomeCategoriesCollectionView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/4/24.
//

import UIKit

final class HomeCategoriesCollectionView: UICollectionView {
    private let layout: UICollectionViewFlowLayout = .init()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        
        backgroundColor = .white
        isScrollEnabled = true
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = .zero
        layout.itemSize = CGSize(width: 73, height: 85)
        layout.minimumLineSpacing = 11

        registerCell(ofType: HomeCategoriesCollectionViewCell.self, withReuseIdentifier: HomeCategoriesCollectionViewCell.reuseIdentifier)
    }
}

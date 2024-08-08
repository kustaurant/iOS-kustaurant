//
//  HomeRestaurantsCollectionView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/5/24.
//

import UIKit

final class HomeRestaurantsCollectionView: UICollectionView {
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
        allowsSelection = true
        showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        
        registerCell(ofType: HomeRestaurantsCollectionViewCell.self, withReuseIdentifier: HomeRestaurantsCollectionViewCell.reuseIdentifier)
    }
}

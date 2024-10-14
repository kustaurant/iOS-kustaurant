//
//  CommunityPostsCollectionView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/14/24.
//

import UIKit

final class CommunityPostsCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommunityPostsCollectionView {
    private func setupCollectionView() {
        backgroundColor = .systemPink.withAlphaComponent(0.3)
        registerCell(ofType: CommunityPostCell.self)
    }
}

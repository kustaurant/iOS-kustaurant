//
//  HomeBannerCollectionView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/15/24.
//

import UIKit

final class HomeBannerCollectionView: UICollectionView {
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
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: HomeBannerSection.sectionHeight)
        registerCell(ofType: HomeBannerCollectionViewCell.self, withReuseIdentifier: HomeBannerCollectionViewCell.reuseIdentifier)
    }
}

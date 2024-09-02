//
//  KuTabBarCollectionView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/3/24.
//

import UIKit

final class KuTabBarCollectionView: UICollectionView {
    
    private let layout: UICollectionViewFlowLayout = .init()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        showsHorizontalScrollIndicator = false
        
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        registerCell(ofType: KuTabBarCollectionViewCell.self)
    }
}


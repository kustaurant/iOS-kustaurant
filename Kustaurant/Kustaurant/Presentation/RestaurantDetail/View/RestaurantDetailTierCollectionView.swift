//
//  RestaurantDetailTierCollectionView.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class RestaurantDetailTierCollectionView: UICollectionView {
    
    enum Constants {
        static let horizontalInset: CGFloat = 20
    }
    
    private let layout: UICollectionViewFlowLayout = .init()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        isScrollEnabled = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        registerCell(ofType: RestaurantDetailTierCell.self)
    }
}

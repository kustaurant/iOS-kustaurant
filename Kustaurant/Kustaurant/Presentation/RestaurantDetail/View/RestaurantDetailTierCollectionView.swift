//
//  RestaurantDetailTierCollectionView.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class LeftAlignCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementKind == nil else { return }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max (layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}

final class RestaurantDetailTierCollectionView: UICollectionView {
    
    private let layout: LeftAlignCollectionViewFlowLayout = .init()
    
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

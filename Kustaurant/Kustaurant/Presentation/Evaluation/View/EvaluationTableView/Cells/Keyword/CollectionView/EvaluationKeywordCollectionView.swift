//
//  EvaluationKeywordCollectionView.swift
//  Kustaurant
//
//  Created by 송우진 on 9/10/24.
//

import UIKit

final class EvaluationKeywordCollectionView: UICollectionView {
    private let layout = CollectionViewLeftAlignFlowLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8

        registerCell(ofType: TierCategoryCollectionViewCell.self)
    }
}

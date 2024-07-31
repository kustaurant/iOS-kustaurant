//
//  UICollectionView+.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

extension Ku where Self: UICollectionView {
    
    func registerCell(
        ofType cellType: UICollectionViewCell.Type,
        withReuseIdentifier identifier: String? = nil
    ) {
        let reuseIdentifier = identifier ?? String(describing: cellType.self)
        self.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        withReuseIdentifier identifier: String? = nil,
        for indexPath: IndexPath
    ) -> T {
        let reuseIdentifier = identifier ?? String(describing: T.self)
        
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? T
        else {
            fatalError("dequeueReusableCell(identifier:) can not dequeue \(reuseIdentifier)")
        }
        
        return cell
    }
    
    func registerSupplementaryView(
        ofType viewType: UICollectionReusableView.Type,
        ofKind elementKind: String = UICollectionView.elementKindSectionHeader,
        withReuseIdentifier identifier: String? = nil
    ) {
        let reuseIdentifier = identifier ?? String(describing: viewType.self)
        self.register(
            viewType,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: reuseIdentifier
        )
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind elementKind: String = UICollectionView.elementKindSectionHeader,
        withReuseIdentifier identifier: String? = nil,
        for indexPath: IndexPath
    ) -> T {
        let reuseIdentifier = identifier ?? String(describing: T.self)
        
        guard let view = dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? T
        else {
            fatalError("dequeueReusableSupplementaryView(identifier:) can not dequeue \(reuseIdentifier)")
        }
        
        return view
    }
}

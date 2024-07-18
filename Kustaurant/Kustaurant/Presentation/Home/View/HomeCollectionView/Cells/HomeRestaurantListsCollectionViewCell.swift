//
//  HomeRestaurantListsCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/18/24.
//

import UIKit

final class HomeRestaurantListsCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: HomeRestaurantListsCollectionViewCell.self)

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

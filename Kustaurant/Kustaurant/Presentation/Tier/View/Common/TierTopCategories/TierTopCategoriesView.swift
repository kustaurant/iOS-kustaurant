//
//  TierTopCategoriesView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/18/24.
//

import UIKit

final class TierTopCategoriesView: UIView {
    let categoryButton = UIButton()
    let categoriesCollectionView = TierTopCategoriesCollectionView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierTopCategoriesView {
    private func setup() {
        addSubview(categoryButton, autoLayout: [.centerY(0), .leading(18), .width(Category.height), .height(Category.height)])
        addSubview(categoriesCollectionView, autoLayout: [.trailing(0), .centerY(0), .height(Category.height), .leadingNext(to: categoryButton, constant: 3)])
        
        configureCategoryButton()
    }
    
    private func configureCategoryButton() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "icon_category")
        categoryButton.configuration = config
    }
}

//
//  UILabel+Style.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

extension UILabel {
    @discardableResult
    func setTierStyle(tier: Tier) -> Self {
        guard tier != .unowned else { return self }
        font = .pretendard(size: 16, weight: .bold)
        text = "\(tier.rawValue)"
        textAlignment = .center
        backgroundColor = tier.backgroundColor()
        textColor = .white
        layer.cornerRadius = 6
        clipsToBounds = true
        return self
    }
    
    @discardableResult
    func setCategoryStyle(
        _ category: Category,
        textInsets: UIEdgeInsets? = nil
    ) -> Self {
        font = .pretendard(size: 14, weight: .regular)
        text = category.displayName
        textAlignment = .center
        textColor = category.isSelect ? .mainGreen : .categoryOff
        layer.borderColor = category.isSelect ? UIColor.mainGreen.cgColor : UIColor.categoryOff.cgColor
        layer.borderWidth = 0.7
        layer.cornerRadius = 16
        backgroundColor = category.isSelect ? .categoryOn : .clear
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Category.Height).isActive = true
        if let paddedLabel = self as? PaddedLabel,
           let textInsets = textInsets {
            paddedLabel.textInsets = textInsets
        }
        return self
    }
    
}

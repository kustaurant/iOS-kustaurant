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
        font = .Pretendard.bold16
        text = "\(tier.rawValue)"
        textAlignment = .center
        backgroundColor = tier.backgroundColor()
        textColor = .white
        layer.cornerRadius = 6
        clipsToBounds = true
        return self
    }
    
    @discardableResult
    func setAttributedText(text: String, highlightedText: String, highlightColor: UIColor) -> Self {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: highlightedText)
        attributedString.addAttribute(.foregroundColor, value: highlightColor, range: range)
        self.attributedText = attributedString
        return self
    }
}

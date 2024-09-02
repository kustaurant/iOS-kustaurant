//
//  UIStackView+AutoLayout.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import UIKit

extension Ku where Self: UIStackView {
    
    func addArrangedSubview(_ view: UIView, proportion: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(view)
        
        if self.axis == .horizontal {
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: proportion).isActive = true
        } else {
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: proportion).isActive = true
        }
    }
    
    func addArrangedSubviews(_ views: [(UIView, CGFloat)]) {
        for (view, proportion) in views {
            addArrangedSubview(view, proportion: proportion)
        }
    }
}

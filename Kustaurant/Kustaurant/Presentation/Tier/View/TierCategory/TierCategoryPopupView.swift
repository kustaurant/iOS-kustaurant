//
//  TierCategoryPopupView.swift
//  Kustaurant
//
//  Created by 송우진 on 8/23/24.
//

import UIKit

final class TierCategoryPopupView: UIView {
    private let imageView = UIImageView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierCategoryPopupView {
    private func setup() {
        let dimmed = UIView()
        dimmed.backgroundColor = .black.withAlphaComponent(0.5)
        addSubview(dimmed, autoLayout: [.fill(0)])
        
        imageView.image = UIImage(named: "popup_tier")?.withRenderingMode(.alwaysOriginal)
        addSubview(imageView, autoLayout: [.center(0)])
        
        addDismissGesture()
    }
    
    private func addDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dimmedViewTapped() {
        removeFromSuperview()
    }
}

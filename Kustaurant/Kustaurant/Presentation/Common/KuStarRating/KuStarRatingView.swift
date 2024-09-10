//
//  KuStarRatingView.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/6/24.
//

import UIKit

final class KuStarRatingView: UIStackView {
    private let starsStackView: KuStarRatingImageView = .init()
    private let label: UILabel = .init()
    
    init() {
        super.init(frame: .zero)
        setupStyle()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(rating: Double) {
        starsStackView.update(rating: rating)
        label.text = "\(rating)"
    }
    
    private func setupStyle() {
        axis = .horizontal
        distribution = .fillProportionally
        alignment = .center
        spacing = 7
        label.font = .Pretendard.regular17
        label.textColor = .Sementic.gray600
    }
    
    private func setupLayout() {
        [starsStackView, label].forEach {
            addArrangedSubview($0)
        }
    }
}

final class KuStarRatingImageView: UIStackView {
    
    private let starImageViews: [UIImageView] = {
        (0..<5).map { _ in
                .init(image: .init(named: "icon_star_empty"))
        }
    }()
    
    init() {
        super.init(frame: .zero)
        setupStyle()
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(rating: Double, width: CGFloat? = 26) {
        let roundedRating = round(rating * 2) / 2
        let fullStarCount = Int(roundedRating)
        let hasHalfStar = (roundedRating - Double(fullStarCount)) == 0.5
        
        starImageViews.forEach { $0.image = .init(named: "icon_star_empty") }
        
        (0..<fullStarCount).forEach { index in
            starImageViews[index].image = .init(named: "icon_star_fill")
        }
        
        if hasHalfStar && fullStarCount < starImageViews.count {
            starImageViews[fullStarCount].image = .init(named: "icon_star_half_fill")
        }
        
        if let width = width {
            setupLayout(width)
        }
    }
    
    private func setupStyle() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
    }
    
    private func setupLayout(_ width: CGFloat = 26) {
        starImageViews.forEach {
            addArrangedSubview($0)
            $0.autolayout([.width(width), .height(width)])
        }
    }
}

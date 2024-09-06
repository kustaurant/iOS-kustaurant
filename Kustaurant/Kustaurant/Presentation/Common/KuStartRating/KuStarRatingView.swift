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

fileprivate final class KuStarRatingImageView: UIStackView {
    
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
    
    func update(rating: Double) {
        let count = Int(rating)
        (0..<count).forEach { index in
            starImageViews[safe: index]?.image = .init(named: "icon_star_fill")
        }
        if rating > Double(count) {
            starImageViews[safe: count + 1]?.image = .init(named: "icon_star_half_fill")
        }
    }
    
    private func setupStyle() {
        axis = .horizontal
        distribution = .fillEqually
        alignment = .center
    }
    
    private func setupLayout() {
        starImageViews.forEach {
            addArrangedSubview($0)
            $0.autolayout([.width(26), .height(26)])
        }
    }
}

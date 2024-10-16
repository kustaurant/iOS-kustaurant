//
//  CommunityFilterView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/16/24.
//

import UIKit

final class CommunityFilterView: UIView {
    private let boardButton: UIButton = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ category: CommunityPostCategory) {
        updateBoardButton(category)
    }
}

extension CommunityFilterView {
    private func setupStyle() {
        backgroundColor = .systemPink.withAlphaComponent(0.5)
    }
    
    private func setupLayout() {
        addSubview(boardButton, autoLayout: [.fillY(0), .leading(9)])
    }
    
    private func updateBoardButton(_ category: CommunityPostCategory) {
        var configuration: UIButton.Configuration = .plain()
        let title = category.rawValue
        configuration.image = UIImage(named: "icon_polygon")
        configuration.imagePadding = 3
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 13, bottom: 4, trailing: 13)
        configuration.imagePlacement = .trailing
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.Pretendard.regular14,
                .foregroundColor: UIColor.mainGreen
            ])
        )
        boardButton.configuration = configuration
    }
}

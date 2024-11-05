//
//  CommunityPostWriteRootView.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import UIKit

final class CommunityPostWriteRootView: UIView {
    private let topBorder: UIView = .init()
    private(set) var selectBoardButton: UIButton = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommunityPostWriteRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
        topBorder.backgroundColor = .gray100
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13)
        configuration.imagePadding = 5
        configuration.image = UIImage(named: "icon_polygon")
        configuration.imagePlacement = .trailing
        configuration.attributedTitle = AttributedString(
            "게시판 선택",
            attributes: AttributeContainer([
                .font: UIFont.Pretendard.regular14,
                .foregroundColor: UIColor.mainGreen
            ])
        )
        selectBoardButton.configuration = configuration
        selectBoardButton.layer.borderWidth = 1.0
        selectBoardButton.layer.borderColor = UIColor.mainGreen.cgColor
        selectBoardButton.layer.cornerRadius = 29/2
    }
    
    private func setupLayout() {
        addSubview(topBorder, autoLayout: [.topSafeArea(constant: 0), .fillX(0), .height(1.5)])
        addSubview(selectBoardButton, autoLayout: [.topSafeArea(constant: 20), .leading(20), .height(29)])
    }
}

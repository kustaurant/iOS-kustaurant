//
//  CommunityFilterView.swift
//  Kustaurant
//
//  Created by 송우진 on 10/16/24.
//

import UIKit

final class CommunityFilterView: UIView {
    private let boardButton: UIButton = .init()
    private let popularButton: UIButton = .init()
    private let recentButton: UIButton = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(
        category: CommunityPostCategory? = nil,
        sortType: CommunityPostSortType? = nil
    ) {
        if let category {
            updateBoardButton(category)
        }
        
        if let sortType {
            switch sortType {
            case .recent:
                updateSortButton(recentButton, type: .recent, isSelect: true)
                updateSortButton(popularButton, type: .popular, isSelect: false)
            case .popular:
                updateSortButton(recentButton, type: .recent, isSelect: false)
                updateSortButton(popularButton, type: .popular, isSelect: true)
            }
        }
    }
}

extension CommunityFilterView {
    private func setupStyle() {
        updateSortButton(recentButton, type: .recent, isSelect: true)
        updateSortButton(popularButton, type: .popular, isSelect: false)
    }
    
    private func setupLayout() {
        addSubview(boardButton, autoLayout: [.fillY(0), .leading(9)])
        
        let stackView = UIStackView(arrangedSubviews: [recentButton, popularButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        stackView.alignment = .center
        recentButton.autolayout([.height(30)])
        popularButton.autolayout([.height(30)])
        addSubview(stackView, autoLayout: [.fillY(0), .trailing(20)])
    }
    
    private func updateSortButton(
        _ button: UIButton,
        type: CommunityPostSortType,
        isSelect: Bool
    ) {
        var configuration: UIButton.Configuration = .plain()
        let title = type.rawValue
        let foregroundColor = isSelect ? UIColor.mainGreen : UIColor.categoryOff
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16)
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.Pretendard.regular14,
                .foregroundColor: foregroundColor
            ])
        )
        button.layer.borderColor = foregroundColor.cgColor
        button.backgroundColor = isSelect ? .categoryOn : .clear
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 15
        button.configuration = configuration
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

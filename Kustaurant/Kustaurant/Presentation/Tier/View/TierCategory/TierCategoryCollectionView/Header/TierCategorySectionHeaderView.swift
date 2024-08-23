//
//  TierCategorySectionHeaderView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/31/24.
//

import UIKit

final class TierCategorySectionHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String = String(describing: TierCategorySectionHeaderView.self)
    static var height: CGFloat = 44
    private let title = UILabel()
    let button = UIButton()
    var model: CategoryType? { didSet { bind() }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierCategorySectionHeaderView {
    private func bind() {
        title.text = model?.rawValue
        configureButton()
    }
    
    private func configureButton() {
        guard let CategoryType = model else { return }
        switch CategoryType {
        case .cuisine:
            button.setAttributedTitle(createUnderlinedText("티어란?"), for: .normal)
        case .situation:
            return
        case .location:
            button.setAttributedTitle(createUnderlinedText("위치에 대한 설명이 필요하다면?"), for: .normal)
        }
    }
}

extension TierCategorySectionHeaderView {
    private func setupUI() {
        addSubviews()
        configureTitle()
    }
    
    private func addSubviews() {
        addSubview(title, autoLayout: [.leading(20), .centerY(0)])
        addSubview(button, autoLayout: [.trailing(20), .centerY(0)])
    }
    
    private func configureTitle() {
        title.textColor = .textBlack
        title.font = UIFont.Pretendard.semiBold17
    }
    
    private func createUnderlinedText(_ title: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Pretendard.medium11,
            .foregroundColor: UIColor.gray600,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.gray600
        ]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        return attributedString
    }
}

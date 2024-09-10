//
//  EvaluationKeywordCell.swift
//  Kustaurant
//
//  Created by 송우진 on 9/9/24.
//

import UIKit

final class EvaluationKeywordCell: UITableViewCell {
    private let containerView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let lineView: UIView = .init()
    let keywrodsCollectionView: EvaluationKeywordCollectionView = EvaluationKeywordCollectionView()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EvaluationKeywordCell {
    private func setupStyle() {
        titleLabel.text = "키워드를 선택해 주세요"
        titleLabel.font = .Pretendard.medium18
        titleLabel.textColor = .textBlack
        
        lineView.backgroundColor = .gray100
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addSubview(titleLabel, autoLayout: [.leading(20), .top(0), .height(42)])
        containerView.addSubview(keywrodsCollectionView, autoLayout: [.topNext(to: titleLabel, constant: 8), .fillX(20), .height(105), .bottom(23)])
        contentView.addSubview(lineView, autoLayout: [.fillX(0), .height(3), .topNext(to: keywrodsCollectionView, constant: 27), .bottom(23)])
    }
}

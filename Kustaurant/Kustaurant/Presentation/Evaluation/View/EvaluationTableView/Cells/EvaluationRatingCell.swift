//
//  EvaluationRatingCell.swift
//  Kustaurant
//
//  Created by 송우진 on 9/11/24.
//

import UIKit

final class EvaluationRatingCell: UITableViewCell {
    private let containerView: UIView = .init()
    private let titleLabel: UILabel = .init()
    
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

extension EvaluationRatingCell {
    private func setupStyle() {
        titleLabel.text = "별점을 선택해 주세요"
        titleLabel.font = .Pretendard.medium18
        titleLabel.textColor = .textBlack
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addSubview(titleLabel, autoLayout: [.leading(20), .top(0), .height(42)])
//        contentView.addSubview(lineView, autoLayout: [.fillX(0), .height(3), .topNext(to: keywrodsCollectionView, constant: 27), .bottom(23)])
    }
}

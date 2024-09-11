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
    private let starRatingView: StarRatingView = StarRatingView()
    private let starCommentsLabel: UILabel = .init()
    private var evaluationData: EvaluationDTO? = nil
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupLayout()
        bindRating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EvaluationRatingCell {
    func update(data: EvaluationDTO?) {
        guard let data = data else { return }
        evaluationData = data
        
        if let score = data.evaluationScore {
            starRatingView.rating = Float(score)
        }
        
        updateComments(rating: starRatingView.rating)
    }
    
    private func updateComments(rating: Float) {
        let comments = evaluationData?.starComments?.compactMap({$0}).first(where: { $0.star == Double(rating) })?.comment ?? ""
        starCommentsLabel.text = comments
    }
    
    private func bindRating() {
        starRatingView.ratingChanged = { [weak self] rating in
            guard rating <= 5.0 else { return }
            self?.updateComments(rating: rating)
        }
    }
}

extension EvaluationRatingCell {
    private func setupStyle() {
        selectionStyle = .none
        
        titleLabel.text = "별점을 선택해 주세요"
        titleLabel.font = .Pretendard.medium18
        titleLabel.textColor = .textBlack
        
        starCommentsLabel.font = .Pretendard.medium15
        starCommentsLabel.textColor = .gray600
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addSubview(titleLabel, autoLayout: [.leading(20), .top(0), .height(42)])
        containerView.addSubview(starRatingView, autoLayout: [.topNext(to: titleLabel, constant: 6), .leading(20), .width(208), .height(40)])
        containerView.addSubview(starCommentsLabel, autoLayout: [.topNext(to: starRatingView, constant: 6), .fillX(20), .bottom(0)])
    }
}

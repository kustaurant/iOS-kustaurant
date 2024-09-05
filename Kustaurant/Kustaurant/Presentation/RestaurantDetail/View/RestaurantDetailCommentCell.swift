//
//  RestaurantDetailCommentCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/11/24.
//

import UIKit
import Combine

final class RestaurantDetailCommentCell: UITableViewCell, RestaurantDetailReviewCellType {
    
    private let iconImageView: UIImageView = .init()
    private let reviewBackgroundView: UIView = .init()
    var reviewView: RestaurantDetailReviewView = .init()
    private let lineView: UIView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailReview else { return }
        
        reviewView.update(item: item)
        lineView.isHidden = item.hasComments
    }
    
    private func setupStyle() {
        selectionStyle = .none
        
        iconImageView.image = .iconReturnRight
        reviewBackgroundView.backgroundColor = .Sementic.gray50
        lineView.backgroundColor = .Sementic.gray75
        
        reviewBackgroundView.layer.cornerRadius = 8
        reviewBackgroundView.clipsToBounds = true
    }
    
    private func setupLayout() {
        reviewBackgroundView.addSubview(reviewView, autoLayout: [.fillX(10), .fillY(12)])
        iconImageView.autolayout([.width(14), .height(12)])
        
        let stackView: UIStackView = .init(arrangedSubviews: [iconImageView, reviewBackgroundView])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(stackView, autoLayout: [.fillX(20), .top(0)])
        contentView.addSubview(lineView, autoLayout: [.fillX(20), .topNext(to: stackView, constant: 22), .bottom(0), .height(2)])
    }

}

// MARK: Like, Dislike
extension RestaurantDetailCommentCell {
        
    func likeButtonPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.likeButtonTapPublisher()
    }
    
    func dislikeButtonPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.dislikeButtonTapPublisher()
    }
    
    func updateReviewView(likeCount: Int, dislikeCount: Int, likeStatus: CommentLikeStatus) {
        reviewView.updateButtonConfiguration(likeCount: likeCount, dislikeCount: dislikeCount, likeStatus: likeStatus)
    }
}

// MARK: Report, Delete
extension RestaurantDetailCommentCell {
    
    func reportTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.reportActionTapPublisher()
    }
    
    func deleteTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.deleteActionTapPublisdher()
    }
}

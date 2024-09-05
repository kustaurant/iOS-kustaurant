//
//  RestaurantDetailReviewCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/4/24.
//

import UIKit
import Combine


final class RestaurantDetailReviewCell: UITableViewCell, RestaurantDetailReviewCellType {
    
    private let starsRatingStackView: StarsRatingStackView = .init()
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
        
        starsRatingStackView.update(rating: item.rating ?? 0)
        reviewView.update(item: item)
        lineView.isHidden = item.hasComments
    }
    
    private func setupStyle() { 
        selectionStyle = .none
        
        lineView.backgroundColor = .gray100
    }
    
    private func setupLayout() {
        let stackView: UIStackView = .init(arrangedSubviews: [starsRatingStackView, reviewView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        contentView.addSubview(stackView, autoLayout: [.fillX(20), .top(22)])
        contentView.addSubview(lineView, autoLayout: [.fillX(20), .topNext(to: stackView, constant: 22), .bottom(0), .height(2)])
    }
}

final class StarsRatingStackView: UIStackView {
    private let starsStackView: StarsStackView = .init()
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
    }
    
    private func setupLayout() {
        [starsStackView, label].forEach {
            addArrangedSubview($0)
        }
    }
}

final class StarsStackView: UIStackView {
    
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

// MARK: Like, Dislike
extension RestaurantDetailReviewCell {
    
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
extension RestaurantDetailReviewCell {
    
    func reportTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.reportActionTapPublisher()
    }
    
    func deleteTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.deleteActionTapPublisdher()
    }
}

extension RestaurantDetailReviewCell {
    
    func commentTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.commentButtonTapPublisher()
    }
}

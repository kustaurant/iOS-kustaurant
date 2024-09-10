//
//  RestaurantDetailReviewCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/4/24.
//

import UIKit
import Combine


final class RestaurantDetailReviewCell: UITableViewCell, RestaurantDetailReviewCellType {
    
    private let starsRatingStackView: KuStarRatingView = .init()
    var reviewView: RestaurantDetailReviewView = .init()
    private let lineView: UIView = .init()
    var cancellables = Set<AnyCancellable>()
    
    var item: RestaurantDetailReview?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.cancellables = Set<AnyCancellable>()
    }
    
    func update(item: RestaurantDetailReview) {
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
    
    func bind(
        item: RestaurantDetailCellItem,
        indexPath: IndexPath,
        viewModel: RestaurantDetailViewModel) {
            guard let item = item as? RestaurantDetailReview else { return }
            self.item = item
            reviewView.likeButtonTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink {
                    viewModel.state = .didTaplikeCommentButton(commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            reviewView.dislikeButtonTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink {
                    viewModel.state = .didTapDislikeCommentButton(commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            reviewView.reportActionTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink {
                    viewModel.state = .didTapReportComment(commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            reviewView.deleteActionTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink {
                    viewModel.state = .didTapDeleteComment(commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            reviewView.commentButtonTapPublisher()
                .sink {
                    viewModel.state = .didTapCommentButton(commentId: item.commentId)
                }
                .store(in: &cancellables)
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
        return reviewView.deleteActionTapPublisher()
    }
}

extension RestaurantDetailReviewCell {
    
    func commentTapPublisher() -> AnyPublisher<Void, Never> {
        return reviewView.commentButtonTapPublisher()
    }
}

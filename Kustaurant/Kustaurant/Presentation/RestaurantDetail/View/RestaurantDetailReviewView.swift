//
//  RestaurantDetailReviewView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/10/24.
//

import UIKit
import Combine

enum RestaurantDetailReviewMenuType {
    case report(commentId: Int)
    case delete(commentId: Int)
}

protocol RestaurantDetailReviewCellType {
    var item: RestaurantDetailReview? { get }
    var reviewView: RestaurantDetailReviewView { get }
    func updateReviewView(likeCount: Int, dislikeCount: Int, likeStatus: CommentLikeStatus)
}

final class RestaurantDetailReviewView: UIView {
    
    private let profileImageView: UIImageView = .init()
    private let nicknameLabel: UILabel = .init()
    private let barView: UIView = .init()
    private let timeLabel: UILabel = .init()
    private let menuEllipsisButton: UIButton = .init()
    
    private let photoImageView: UIImageView = .init()
    private let reviewLabel: UILabel = .init()
    
    private let likeButton: UIButton = .init()
    private let dislikeButton: UIButton = .init()
    private let commentsButton: UIButton = .init()
    
    private var likeButtonWidthConstraint: NSLayoutConstraint?
    private var dislikeButtonWidthConstraint: NSLayoutConstraint?
    
    private let reportTapSubject = PassthroughSubject<Void, Never>()
    private let deleteTapSubject = PassthroughSubject<Void, Never>()
    private let photoImageViewSubject = PassthroughSubject<Void, Never>()
    
    init() {
        super.init(frame: .zero)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        
        profileImageView.contentMode = .scaleAspectFill
        
        nicknameLabel.font = .Pretendard.bold13
        nicknameLabel.textColor = .Sementic.gray800
        
        timeLabel.font = .Pretendard.regular12
        timeLabel.textColor = .Sementic.gray600
        
        photoImageView.isHidden = true
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
        
        reviewLabel.font = .Pretendard.regular14
        reviewLabel.textColor = .Sementic.gray800
        reviewLabel.numberOfLines = 0
        
        commentsButton.setImage(UIImage(named: "icon_comment"), for: .normal)
        menuEllipsisButton.setImage(UIImage(named: "icon_ellipsis"), for: .normal)
        menuEllipsisButton.tintColor = .Sementic.gray75
    }
    
    private func setupLayout() {
        let topView = UIView()
        topView.addSubview(profileImageView, autoLayout: [.leading(0), .top(0), .centerY(0)])
        topView.addSubview(nicknameLabel, autoLayout: [.leadingNext(to: profileImageView, constant: 5), .top(0), .centerY(0)])
        topView.addSubview(barView, autoLayout: [.leadingNext(to: nicknameLabel, constant: 10), .top(0), .width(1), .height(14), .centerY(0)])
        topView.addSubview(timeLabel, autoLayout: [.leadingNext(to: barView, constant: 10), .top(0), .centerY(0)])
        topView.addSubview(menuEllipsisButton, autoLayout: [.trailing(0), .top(0), .centerY(0)])
        
        profileImageView.autolayout([.height(24), .width(24)])
        
        let interactionStackView = UIStackView(arrangedSubviews: [likeButton, dislikeButton, commentsButton, SpaceView()])
        interactionStackView.axis = .horizontal
        interactionStackView.alignment = .center
        interactionStackView.spacing = 12
        interactionStackView.distribution = .fillProportionally
        likeButtonWidthConstraint = likeButton.widthAnchor.constraint(equalToConstant: 30)
        likeButtonWidthConstraint?.isActive = true
        dislikeButtonWidthConstraint = dislikeButton.widthAnchor.constraint(equalToConstant: 30)
        dislikeButtonWidthConstraint?.isActive = true
        commentsButton.autolayout([.width(14)])
        photoImageView.autolayout([.width(207), .height(207)])
        
        let mainStackView = UIStackView(arrangedSubviews: [topView, photoImageView, reviewLabel, interactionStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 11
        
        addSubview(mainStackView, autoLayout: [.fill(0)])
    }
    
    private func loadImage(_ urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString)
        else { return }
        Task {
            let image = await ImageCacheManager.shared.loadImage(
                from: url,
                targetSize: CGSize(width: 24, height: 24),
                defaultImage: UIImage(systemName: "person.fill")
            )
            await MainActor.run {
                profileImageView.image = image
            }
        }
    }
    
    func update(item: RestaurantDetailReview) {
        loadImage(item.profileImageURLString)
        nicknameLabel.text = item.nickname
        barView.backgroundColor = .Sementic.gray50
        timeLabel.text = item.time
        photoImageView.isHidden = true
//        if let url = URL(string: item.photoImageURLString) {
//            ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
//                self?.photoImageViewSubject.send()
//                self?.photoImageView.image = image
//                self?.photoImageView.isHidden = image == nil
//            }
//        }
        reviewLabel.text = item.review
        commentsButton.isHidden = item.isComment
        likeButton.configuration?.title = "\(item.likeCount)"
        likeButtonWidthConstraint?.constant = likeButton.intrinsicContentSize.width
        dislikeButton.configuration?.title = "\(item.dislikeCount)"
        dislikeButtonWidthConstraint?.constant = dislikeButton.intrinsicContentSize.width
        
        updateButtonConfiguration(likeCount: item.likeCount, dislikeCount: item.dislikeCount, likeStatus: item.likeStatus)
        setupMenuEllipsisButton(with: item)
        layoutIfNeeded()
    }
    
    func commentButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return commentsButton.tapPublisher()
    }

    func photoImageReloadPublisher() -> AnyPublisher<Void, Never> {
        return photoImageViewSubject.eraseToAnyPublisher()
    }
}

// MARK: Like, Dislike
extension RestaurantDetailReviewView {
    
    func likeButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return likeButton.tapPublisher()
    }
    
    func dislikeButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return dislikeButton.tapPublisher()
    }
    
    func updateButtonConfiguration(likeCount: Int, dislikeCount: Int, likeStatus: CommentLikeStatus) {
        var likeConfiguration: UIButton.Configuration = .plain()
        let likeTitle = "\(likeCount)"
        likeConfiguration.image = UIImage(named: likeStatus.thumbsUpIconImageName)
        likeConfiguration.imagePadding = 4
        likeConfiguration.contentInsets = .zero
        likeConfiguration.attributedTitle = AttributedString(likeTitle, attributes: AttributeContainer([
            .font: UIFont.Pretendard.regular11,
            .foregroundColor: likeStatus.foregroundColor
        ]))
        likeButton.configuration = likeConfiguration
        
        var dislikeConfiguration: UIButton.Configuration = .plain()
        let dislikeTitle = "\(dislikeCount)"
        dislikeConfiguration.image = UIImage(named: likeStatus.thumbsDownIconImageName)
        dislikeConfiguration.imagePadding = 4
        dislikeConfiguration.contentInsets = .zero
        dislikeConfiguration.attributedTitle = AttributedString(dislikeTitle, attributes: AttributeContainer([
            .font: UIFont.Pretendard.regular11,
            .foregroundColor: likeStatus.foregroundColor
        ]))
        dislikeButton.configuration = dislikeConfiguration
    }
}

// MARK: Menu
extension RestaurantDetailReviewView {
    
    func reportActionTapPublisher() -> AnyPublisher<Void, Never> {
        return reportTapSubject.eraseToAnyPublisher()
    }
    
    func deleteActionTapPublisher() -> AnyPublisher<Void, Never> {
        return deleteTapSubject.eraseToAnyPublisher()
    }
    
    private func setupMenuEllipsisButton(with item: RestaurantDetailReview) {
        var actions: [UIAction] = []
        
        let reportAction = UIAction(title: "신고하기", image: UIImage(named: "icon_shield")) { [weak self] _ in
            self?.reportTapSubject.send()
        }
        actions.append(reportAction)
        
        if item.isCommentMine {
            let deleteAction = UIAction(title: "삭제하기", image: UIImage(named: "icon_trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteTapSubject.send()
            }
            actions.append(deleteAction)
        }
        
        let menu = UIMenu(title: "", children: actions)
        menuEllipsisButton.menu = menu
        menuEllipsisButton.showsMenuAsPrimaryAction = true
    }
}

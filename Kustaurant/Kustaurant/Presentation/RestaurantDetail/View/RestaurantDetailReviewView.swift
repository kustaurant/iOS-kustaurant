//
//  RestaurantDetailReviewView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/10/24.
//

import UIKit

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
    
    init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailReview) {
        profileImageView.image = UIImage(systemName: "person.fill")
        if let url = URL(string: item.profileImageURLString) {
            ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
                self?.profileImageView.image = image
            }
        }
        nicknameLabel.text = item.nickname
        barView.backgroundColor = .gray100
        timeLabel.text = item.time
        photoImageView.isHidden = true
        if let url = URL(string: item.photoImageURLString) {
            ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
                self?.photoImageView.image = image
                self?.photoImageView.isHidden = image == nil
            }
        }
        reviewLabel.text = item.review
        
        likeButton.configuration?.title = "\(item.likeCount)"
        likeButtonWidthConstraint?.constant = likeButton.intrinsicContentSize.width
        
        dislikeButton.configuration?.title = "\(item.dislikeCount)"
        dislikeButtonWidthConstraint?.constant = dislikeButton.intrinsicContentSize.width
        
        commentsButton.isHidden = item.isComment
        
        layoutIfNeeded()
    }
    
    private func setupStyle() {
        nicknameLabel.font = .boldSystemFont(ofSize: 14)
        nicknameLabel.textColor = .black
        
        timeLabel.font = .systemFont(ofSize: 12)
        timeLabel.textColor = .gray
        
        photoImageView.contentMode = .scaleAspectFill
        
        reviewLabel.font = .systemFont(ofSize: 14)
        reviewLabel.textColor = .black
        reviewLabel.numberOfLines = 0
        
        commentsButton.setImage(UIImage(named: "icon_comment"), for: .normal)
        
        var likeConfiguration: UIButton.Configuration = .plain()
        likeConfiguration.image = UIImage(named: "icon_thumb_up")
        likeConfiguration.imagePadding = 4
        likeConfiguration.contentInsets = .zero
        likeButton.configuration = likeConfiguration
        
        var dislikeConfiguration: UIButton.Configuration = .plain()
        dislikeConfiguration.image = UIImage(named: "icon_thumb_down")
        dislikeConfiguration.imagePadding = 4
        dislikeConfiguration.contentInsets = .zero
        dislikeButton.configuration = dislikeConfiguration
        
        menuEllipsisButton.setImage(UIImage(named: "ellipsis"), for: .normal)
    }
    
    private func setupLayout() {
        let topStackView = UIStackView(arrangedSubviews: [profileImageView, nicknameLabel, barView, timeLabel, menuEllipsisButton])
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.spacing = 8
        
        profileImageView.autolayout([.height(24), .width(24)])
        barView.autolayout([.width(1), .height(14)])
        menuEllipsisButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
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
        
        let mainStackView = UIStackView(arrangedSubviews: [topStackView, photoImageView, reviewLabel, interactionStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 11
        
        photoImageView.autolayout([.height(207), .width(207)])
        addSubview(mainStackView, autoLayout: [.fill(0)])
    }
}

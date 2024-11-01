//
//  CommunityPostDetailCommentCell.swift
//  Kustaurant
//
//  Created by 송우진 on 11/1/24.
//

import UIKit

final class CommunityPostDetailCommentCell: DefaultTableViewCell {
    private let rankImageView: UIImageView = .init()
    private let userNicknameLabel: UILabel = .init()
    private let timeAgoLabel: UILabel = .init()
    private let menuEllipsisButton: UIButton = .init()
    private let bodyLabel: UILabel = .init()
    private var likeButton: UIButton = .init()
    private var dislikeButton: UIButton = .init()
    private let commentsButton: UIButton = .init()
    private enum ButtonType {
        case like, dislike
    }
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankImageView.image = nil
    }
    
    func update(_ data: CommunityPostDTO.PostComment) {
        userNicknameLabel.text = data.user?.userNickname
        timeAgoLabel.text = data.timeAgo
        bodyLabel.text = data.commentBody
        updateButton(button: &likeButton, type: .like, count: data.likeCount ?? 0, isActive: data.isLiked ?? false)
        updateButton(button: &dislikeButton, type: .dislike, count: data.dislikeCount ?? 0, isActive: data.isDisliked ?? false)
        Task {
            await loadImage(rankImageView, urlString: data.user?.rankImg, targetSize: CGSize(width: 25, height: 24))
        }
    }
}

extension CommunityPostDetailCommentCell {
    private func setupCell() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        rankImageView.contentMode = .scaleAspectFill
        userNicknameLabel.font = .Pretendard.bold13
        userNicknameLabel.textColor = .textBlack
        timeAgoLabel.textAlignment = .left
        timeAgoLabel.font = .Pretendard.medium12
        timeAgoLabel.textColor = .gray600
        bodyLabel.numberOfLines = 0
        bodyLabel.font = .Pretendard.medium13
        bodyLabel.textColor = .gray800
        menuEllipsisButton.setImage(UIImage(named: "icon_ellipsis"), for: .normal)
        menuEllipsisButton.tintColor = .Sementic.gray75
        commentsButton.setImage(UIImage(named: "icon_comment"), for: .normal)
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.red.cgColor
    }
    
    private func updateButton(
        button: inout UIButton,
        type: ButtonType,
        count: Int,
        isActive: Bool
    ) {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .clear
        let targetImageString: String
        switch type {
        case .like:
            targetImageString = isActive ? CommentLikeStatus.liked.thumbsUpIconImageName : CommentLikeStatus.none.thumbsUpIconImageName
        case .dislike:
            targetImageString = isActive ? CommentLikeStatus.disliked.thumbsDownIconImageName : CommentLikeStatus.none.thumbsDownIconImageName
        }
        configuration.image = UIImage(named: targetImageString)
        configuration.imagePadding = 4
        configuration.contentInsets = .zero
        configuration.attributedTitle = AttributedString("\(count)", attributes: AttributeContainer([
            .font: UIFont.Pretendard.regular11,
            .foregroundColor: isActive ? UIColor.mainGreen : UIColor.gray300
        ]))
        button.configuration = configuration
    }
    
    private func setupLayout() {
        let line = UIView()
        line.backgroundColor = .gray75
        
        let topContainerView = UIView()
        topContainerView.addSubview(rankImageView, autoLayout: [.leading(0), .fillY(0), .width(25), .height(24)])
        topContainerView.addSubview(userNicknameLabel, autoLayout: [.centerY(0), .leadingNext(to: rankImageView, constant: 4)])
        topContainerView.addSubview(line, autoLayout: [.leadingNext(to: userNicknameLabel, constant: 10), .centerY(0), .height(14), .width(1)])
        topContainerView.addSubview(timeAgoLabel, autoLayout: [.leadingNext(to: line, constant: 10), .centerY(0)])
        topContainerView.addSubview(menuEllipsisButton, autoLayout: [.centerY(0), .trailing(0)])
        
        let bottomContainerView = UIView()
        bottomContainerView.addSubview(likeButton, autoLayout: [.leading(0), .centerY(0)])
        bottomContainerView.addSubview(dislikeButton, autoLayout: [.leadingNext(to: likeButton, constant: 12), .centerY(0)])
        bottomContainerView.addSubview(commentsButton, autoLayout: [.leadingNext(to: dislikeButton, constant: 12), .width(14), .height(15), .fillY(0)])
        
        let stackView = UIStackView(arrangedSubviews: [topContainerView, bodyLabel, bottomContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 11
        contentView.addSubview(stackView, autoLayout: [.fillY(0), .fillX(20)])
    }
}

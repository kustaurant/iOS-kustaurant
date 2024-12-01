//
//  DefaultCommunityPostDetailCommentCell.swift
//  Kustaurant
//
//  Created by 송우진 on 11/29/24.
//

import UIKit

class DefaultCommunityPostDetailCommentCell: DefaultTableViewCell {
    let rankImageView: UIImageView = .init()
    let userNicknameLabel: UILabel = .init()
    let timeAgoLabel: UILabel = .init()
    let menuEllipsisButton: EllipsisMenuButton = .init()
    let bodyLabel: UILabel = .init()
    var likeButton: UIButton = .init()
    var dislikeButton: UIButton = .init()
    var commentId: Int?
    var likeButtonTouched: ((Int?) -> Void)?
    var dislikeButtonTouched: ((Int?) -> Void)?
    var ellipsisReportTouched: ((Int?) -> Void)?
    var ellipsisDeleteTouched: ((Int?) -> Void)?
    var commentsButtonTouched: ((Int?) -> Void)?
    
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
    
    func setupStyle() {
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
    }
    
    func setupBind() {
        likeButton.addAction(
            UIAction { [weak self] _ in
                self?.likeButtonTouched?(self?.commentId)
            } , for: .touchUpInside)
        dislikeButton.addAction(
            UIAction { [weak self] _ in
                self?.dislikeButtonTouched?(self?.commentId)
            } , for: .touchUpInside)
        
        menuEllipsisButton.onDeleteAction = { [weak self] in
            self?.ellipsisDeleteTouched?(self?.commentId)
        }
        
        menuEllipsisButton.onReportAction = { [weak self] in
            self?.ellipsisReportTouched?(self?.commentId)
        }
    }
    
    func update(_ data: CommunityPostDTO.PostComment) {
        commentId = data.commentId
        userNicknameLabel.text = data.user?.userNickname
        timeAgoLabel.text = data.timeAgo
        bodyLabel.text = data.commentBody
        updateButton(button: &likeButton, type: .like, count: data.likeCount ?? 0, isActive: data.isLiked ?? false)
        updateButton(button: &dislikeButton, type: .dislike, count: data.dislikeCount ?? 0, isActive: data.isDisliked ?? false)
        menuEllipsisButton.isMine = data.isCommentMine ?? false
        menuEllipsisButton.isHidden = !(data.isCommentMine ?? false)
        menuEllipsisButton.isReportHidden = true
        Task {
            let image = await loadImage(urlString: data.user?.rankImg, targetSize: CGSize(width: 25, height: 24))
            await MainActor.run {
                rankImageView.image = image
            }
        }
    }
}

extension DefaultCommunityPostDetailCommentCell {
    private func setupCell() {
        setupStyle()
        setupBind()
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
}

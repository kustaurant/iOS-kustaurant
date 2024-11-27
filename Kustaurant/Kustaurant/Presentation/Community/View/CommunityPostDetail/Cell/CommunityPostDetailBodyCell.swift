//
//  CommunityPostDetailBodyCell.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

final class CommunityPostDetailBodyCell: DefaultTableViewCell {
    private let rankImageView: UIImageView = .init()
    private let userNicknameLabel: UILabel = .init()
    private let timeAgoLabel: UILabel = .init()
    private let titleLabel: UILabel = .init()
    private let photoImageView: UIImageView = .init()
    private let bodyLabel: UILabel = .init()
    private let postVisitCountLabel: UILabel = .init()
    private let commentCountLabel: UILabel = .init()
    private var likeButton: UIButton = .init()
    private var scrapButton: UIButton = .init()
    
    private let padding: CGFloat = 16
    private lazy var photoImageViewSize = {
        let width = UIScreen.main.bounds.width - (padding * 2)
        let height = width * 0.69375
        return CGSize(width: width, height: height)
    }()
    
    private var photoImageViewTopConstraint: NSLayoutConstraint?
    private var photoImageViewHeightConstraint: NSLayoutConstraint?
    
    var likeButtonTouched: (() -> Void)?
    var scrapButtonTouched: (() -> Void)?
    
    private enum ButtonType {
        case like, scrap
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
        photoImageView.image = nil
    }
    
    func update(_ model: CommunityPostDetailBody) {
        userNicknameLabel.text = model.user?.userNickname
        timeAgoLabel.text = model.timeAgo
        titleLabel.text = model.postTitle
        bodyLabel.text = model.postBody
        postVisitCountLabel.text = "조회수 \(model.postVisitCount)"
        commentCountLabel.text = "댓글 \(model.commentCount)"
        updateButton(button: &likeButton, type: .like, count: model.likeCount, isLiked: model.isliked)
        updateButton(button: &scrapButton, type: .scrap, count: model.scrapCount, isScraped: model.isScraped)
        
        photoImageViewTopConstraint?.constant = (model.postPhotoImgUrl != nil) ? 11 : 0
        photoImageViewHeightConstraint?.constant = (model.postPhotoImgUrl != nil) ? photoImageViewSize.height : 0
        
        Task {
            let rankImage = await loadImage(urlString: model.user?.rankImg, targetSize: CGSize(width: 25, height: 24))
            let photoImage = await loadImage(urlString: model.postPhotoImgUrl, targetSize: nil)
            await MainActor.run {
                rankImageView.image = rankImage
                photoImageView.image = photoImage
            }
        }
    }
}

extension CommunityPostDetailBodyCell {
    private func setupCell() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        rankImageView.contentMode = .scaleAspectFill
        userNicknameLabel.font = .Pretendard.medium12
        userNicknameLabel.textColor = .gray600
        timeAgoLabel.textAlignment = .left
        timeAgoLabel.font = .Pretendard.medium12
        timeAgoLabel.textColor = .gray600
        titleLabel.font = .Pretendard.bold18
        titleLabel.textColor = .textBlack
        photoImageView.contentMode = .scaleAspectFit
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 10
        bodyLabel.numberOfLines = 0
        bodyLabel.font = .Pretendard.medium13
        bodyLabel.textColor = .gray800
        postVisitCountLabel.font = .Pretendard.medium12
        postVisitCountLabel.textColor = .gray800
        commentCountLabel.font = .Pretendard.medium12
        commentCountLabel.textColor = .gray800
        updateButton(button: &scrapButton, type: .scrap)
        updateButton(button: &likeButton, type: .like)
        
        likeButton.addAction(
            UIAction { [weak self] _ in
                self?.likeButtonTouched?()
            } , for: .touchUpInside)
        scrapButton.addAction(
            UIAction { [weak self] _ in
                self?.scrapButtonTouched?()
            } , for: .touchUpInside)
    }
    
    private func updateButton(
        button: inout UIButton,
        type: ButtonType,
        count: Int = 0,
        isLiked: Bool = false,
        isScraped: Bool = false
    ) {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let targetImage: UIImage?
        let targetColor: UIColor
        
        switch type {
        case .like:
            targetColor = isLiked ? .mainGreen : .gray300
            targetImage = UIImage(named: "icon_thumbs_up_deactivated")?.withTintColor(targetColor, renderingMode: .alwaysOriginal)
        case .scrap:
            targetColor = isScraped ? .mainGreen : .gray300
            targetImage = UIImage(named: "icon_scrap")?.withTintColor(targetColor, renderingMode: .alwaysOriginal)
        }

        configuration.image = targetImage
        configuration.imagePadding = 5
        configuration.attributedTitle = AttributedString(
            "\(count)",
            attributes: AttributeContainer([
                .font: UIFont.Pretendard.regular13,
                .foregroundColor: targetColor
            ])
        )
        button.configuration = configuration
        button.layer.borderWidth = 1.0
        button.layer.borderColor = targetColor.cgColor
        button.layer.cornerRadius = 29/2
    }
    
    private func setupLayout() {
        let line = UIView()
        line.backgroundColor = .gray75
        
        let userContainerView = UIView()
        userContainerView.addSubview(rankImageView, autoLayout: [.leading(0), .fillY(0), .width(25), .height(24)])
        userContainerView.addSubview(userNicknameLabel, autoLayout: [.fillY(0), .leadingNext(to: rankImageView, constant: 4)])
        userContainerView.addSubview(line, autoLayout: [.leadingNext(to: userNicknameLabel, constant: 10), .fillY(0), .height(14), .width(1)])
        userContainerView.addSubview(timeAgoLabel, autoLayout: [.leadingNext(to: line, constant: 10), .fillY(0)])
        
        let contentContainerView = UIView()
        contentContainerView.addSubview(titleLabel, autoLayout: [.top(0), .fillX(0)])
        contentContainerView.addSubview(photoImageView, autoLayout: [.fillX(0)])
        contentContainerView.addSubview(bodyLabel, autoLayout: [.topNext(to: photoImageView, constant: 15), .fillX(0), .bottom(0)])
        photoImageViewTopConstraint = photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11)
        photoImageViewTopConstraint?.isActive = true
        photoImageViewHeightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: photoImageViewSize.height)
        photoImageViewHeightConstraint?.isActive = true
        
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        let interactionContainer = UIView()
        interactionContainer.addSubview(postVisitCountLabel, autoLayout: [.fillY(0), .leading(0)])
        interactionContainer.addSubview(commentCountLabel, autoLayout: [.fillY(0), .leadingNext(to: postVisitCountLabel, constant: 9)])
        interactionContainer.addSubview(scrapButton, autoLayout: [.trailing(0), .fillY(0), .height(29)])
        interactionContainer.addSubview(likeButton, autoLayout: [.trailingNext(to: scrapButton, constant: 7), .fillY(0), .height(29)])
        
        let stackView = UIStackView(arrangedSubviews: [userContainerView, contentContainerView, spacer, interactionContainer])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        contentView.addSubview(stackView, autoLayout: [.top(29), .bottom(20), .fillX(padding)])

    }
}

//
//  CommunityPostCell.swift
//  Kustaurant
//
//  Created by 송우진 on 10/14/24.
//

import UIKit

final class CommunityPostCell: UICollectionViewCell {
    private let photoImageView: UIImageView = .init()
    private let rankImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private let categoryLabel: PaddedLabel = .init()
    private let bodyLabel: UILabel = .init()
    private let userNicknameLabel: UILabel = .init()
    private let timeAgoLabel: UILabel = .init()
    private let likeButton: UIButton = .init()
    private let commentsButton: UIButton = .init()
    private let bottomLine: UIView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankImageView.image = nil
        photoImageView.image = nil
    }
    
    func update(_ model: CommunityPostDTO) {
        categoryLabel.text = model.postCategory
        titleLabel.text = model.postTitle
        bodyLabel.text = model.postBody
        userNicknameLabel.text = model.user?.userNickname
        timeAgoLabel.text = model.timeAgo
        updateLikeButton(count: model.likeCount, isLiked: model.isliked)
        updateCommentsButton(count: model.commentCount)
        Task {
            await loadImage(rankImageView, urlString: model.user?.rankImg, targetSize: CGSize(width: 16, height: 16))
            await loadImage(photoImageView, urlString: model.postPhotoImgUrl, targetSize: CGSize(width: 71, height: 71))
        }
    }
}

extension CommunityPostCell {
    private func setupStyle() {
        photoImageView.layer.cornerRadius = 5
        photoImageView.clipsToBounds = true
        
        categoryLabel.backgroundColor = .gray100
        categoryLabel.textColor = .gray300
        categoryLabel.font = .Pretendard.medium11
        categoryLabel.layer.cornerRadius = 2
        categoryLabel.textInsets = UIEdgeInsets(top: 3, left: 4, bottom: 3, right: 4)
        categoryLabel.clipsToBounds = true
        categoryLabel.textAlignment = .center
        
        titleLabel.font = .Pretendard.semiBold15
        titleLabel.textColor = .textBlack
        
        bodyLabel.font = .Pretendard.medium13
        bodyLabel.textColor = .textBlack
        
        userNicknameLabel.font = .Pretendard.medium11
        userNicknameLabel.textColor = .gray300
        
        timeAgoLabel.font = .Pretendard.medium11
        timeAgoLabel.textColor = .gray300
        
        bottomLine.backgroundColor = .gray75
    }
    
    private func setupLayout() {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        let line = UIView()
        line.backgroundColor = .gray75
        let line2 = UIView()
        line2.backgroundColor = .gray75
        
        let bottomCntainerView = UIView()
        bottomCntainerView.addSubview(rankImageView, autoLayout: [.leading(0), .fillY(0), .width(16), .height(16)])
        bottomCntainerView.addSubview(userNicknameLabel, autoLayout: [.fillY(0), .leadingNext(to: rankImageView, constant: 3)])
        bottomCntainerView.addSubview(line, autoLayout: [.leadingNext(to: userNicknameLabel, constant: 7), .fillY(0), .height(14), .width(1)])
        bottomCntainerView.addSubview(timeAgoLabel, autoLayout: [.leadingNext(to: line, constant: 7), .fillY(0)])
        bottomCntainerView.addSubview(line2, autoLayout: [.leadingNext(to: timeAgoLabel, constant: 7), .fillY(0), .height(14), .width(1)])
        bottomCntainerView.addSubview(likeButton, autoLayout: [.leadingNext(to: line2, constant: 10), .fillY(0)])
        bottomCntainerView.addSubview(commentsButton, autoLayout: [.leadingNext(to: likeButton, constant: 7), .fillY(0)])
        
        let verticalStacView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel, spacer, bottomCntainerView])
        verticalStacView.axis = .vertical
        verticalStacView.spacing = 5
        verticalStacView.distribution = .fill
        
        contentView.addSubview(photoImageView, autoLayout: [.top(24), .trailing(1), .width(71), .height(71)])
        
        contentView.addSubview(categoryLabel, autoLayout: [.top(0), .leading(0)])
        contentView.addSubview(verticalStacView, autoLayout: [.topNext(to: categoryLabel, constant: 8), .leading(0), .trailingNext(to: photoImageView, constant: 22)])
        contentView.addSubview(bottomLine, autoLayout: [.fillX(0), .bottom(0), .height(0.5)])
    }
    
    private func loadImage(
        _ imageView: UIImageView,
        urlString: String?,
        targetSize: CGSize?
    ) async {
        guard let urlString,
              let url = URL(string: urlString)
        else { return }
        let image = await ImageCacheManager.shared.loadImage(from: url, targetSize: targetSize)
        await MainActor.run {
            imageView.image = image
        }
    }
    
    private func updateLikeButton(
        count: Int?,
        isLiked: Bool?
    ) {
        guard let count else { return }
        var configuration: UIButton.Configuration = .plain()
        let title = "\(count)"
        let likeStatus: CommentLikeStatus = (isLiked ?? false) ? .liked : .disliked
        configuration.image = UIImage(named: likeStatus.thumbsUpIconImageName)
        configuration.imagePadding = 4
        configuration.contentInsets = .zero
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.Pretendard.regular11,
            .foregroundColor: likeStatus.foregroundColor
        ]))
        likeButton.configuration = configuration
    }
    
    private func updateCommentsButton(count: Int?) {
        guard let count else { return }
        var configuration: UIButton.Configuration = .plain()
        let title = "\(count)"
        configuration.image = UIImage(named: "icon_comment")
        configuration.imagePadding = 4
        configuration.contentInsets = .zero
        configuration.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.Pretendard.regular11,
            .foregroundColor: UIColor.gray300
        ]))
        commentsButton.configuration = configuration
    }
}

extension CommunityPostCell {
    static func layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(110))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(110))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 60, trailing: 20)
        section.interGroupSpacing = 12
        return section
    }
}

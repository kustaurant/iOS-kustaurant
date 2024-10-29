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
    
    private let padding: CGFloat = 16
    private lazy var photoImageViewSize = {
        let width = UIScreen.main.bounds.width - (padding * 2)
        let height = width * 0.69375
        return CGSize(width: width, height: height)
    }()
    
    private var photoImageViewTopConstraint: NSLayoutConstraint?
    private var photoImageViewHeightConstraint: NSLayoutConstraint?
    
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
        photoImageViewTopConstraint?.constant = (model.postPhotoImgUrl != nil) ? 11 : 0
        photoImageViewHeightConstraint?.constant = (model.postPhotoImgUrl != nil) ? photoImageViewSize.height : 0
        
        Task {
            await loadImage(rankImageView, urlString: model.user?.rankImg, targetSize: CGSize(width: 25, height: 24))
            await loadImage(photoImageView, urlString: model.postPhotoImgUrl, targetSize: photoImageViewSize)
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
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.borderWidth = 1.0
        bodyLabel.numberOfLines = 0
        bodyLabel.font = .Pretendard.medium13
        bodyLabel.textColor = .gray800
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
        contentContainerView.addSubview(bodyLabel, autoLayout: [.topNext(to: photoImageView, constant: 15), .fillX(0)])
        
        photoImageViewTopConstraint = photoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11)
        photoImageViewTopConstraint?.isActive = true
        photoImageViewHeightConstraint = photoImageView.heightAnchor.constraint(equalToConstant: photoImageViewSize.height)
        photoImageViewHeightConstraint?.isActive = true
        
        
        
        let stackView = UIStackView(arrangedSubviews: [userContainerView, contentContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        contentView.addSubview(stackView, autoLayout: [.fillY(29), .fillX(padding)])

    }
}

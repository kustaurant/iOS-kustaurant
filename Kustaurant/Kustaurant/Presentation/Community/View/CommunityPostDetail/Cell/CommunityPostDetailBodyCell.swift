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
    
    func update(_ body: CommunityPostDetailBody) {
        userNicknameLabel.text = body.user?.userNickname
        timeAgoLabel.text = body.timeAgo
        Task {
            await loadImage(rankImageView, urlString: body.user?.rankImg, targetSize: CGSize(width: 25, height: 24))
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
    }
    
    private func setupLayout() {
        let line = UIView()
        line.backgroundColor = .gray75
        
        let userContainerView = UIView()
        userContainerView.addSubview(rankImageView, autoLayout: [.leading(0), .fillY(0), .width(25), .height(24)])
        userContainerView.addSubview(userNicknameLabel, autoLayout: [.fillY(0), .leadingNext(to: rankImageView, constant: 4)])
        userContainerView.addSubview(line, autoLayout: [.leadingNext(to: userNicknameLabel, constant: 10), .fillY(0), .height(14), .width(1)])
        userContainerView.addSubview(timeAgoLabel, autoLayout: [.leadingNext(to: line, constant: 10), .fillY(0)])
        contentView.addSubview(userContainerView, autoLayout: [.top(30), .fillX(16), .bottom(0)])
    }
}

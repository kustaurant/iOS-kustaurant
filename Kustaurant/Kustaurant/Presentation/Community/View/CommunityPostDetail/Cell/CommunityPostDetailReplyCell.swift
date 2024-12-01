//
//  CommunityPostDetailReplyCell.swift
//  Kustaurant
//
//  Created by 송우진 on 11/29/24.
//

import UIKit

final class CommunityPostDetailReplyCell: DefaultCommunityPostDetailCommentCell {
    private let returnIconImageView: UIImageView = .init()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyle() {
        super.setupStyle()
        returnIconImageView.image = UIImage(named: "icon_return_right")
//        contentView.backgroundColor = .red.withAlphaComponent(0.3)
    }
}

extension CommunityPostDetailReplyCell {
    private func setupLayout() {
        let line = UIView()
        line.backgroundColor = .gray75
        
        let stackContaierView = UIView()
        stackContaierView.backgroundColor = .gray100
        stackContaierView.layer.cornerRadius = 6
        
        let topContainerView = UIView()
        topContainerView.addSubview(rankImageView, autoLayout: [.leading(0), .fillY(0), .width(25), .height(24)])
        topContainerView.addSubview(userNicknameLabel, autoLayout: [.centerY(0), .leadingNext(to: rankImageView, constant: 4)])
        topContainerView.addSubview(line, autoLayout: [.leadingNext(to: userNicknameLabel, constant: 10), .centerY(0), .height(14), .width(1)])
        topContainerView.addSubview(timeAgoLabel, autoLayout: [.leadingNext(to: line, constant: 10), .centerY(0)])
        topContainerView.addSubview(menuEllipsisButton, autoLayout: [.centerY(0), .trailing(0), .width(20)])
        
        let bottomContainerView = UIView()
        bottomContainerView.addSubview(likeButton, autoLayout: [.leading(0), .centerY(0)])
        bottomContainerView.addSubview(dislikeButton, autoLayout: [.leadingNext(to: likeButton, constant: 12), .fillY(0)])
        
        let stackView = UIStackView(arrangedSubviews: [topContainerView, bodyLabel, bottomContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 11
        stackView.backgroundColor = .gray100
        
        stackContaierView.addSubview(stackView, autoLayout: [.top(12), .bottom(14), .leading(10), .trailing(15)])
        
        contentView.addSubview(returnIconImageView, autoLayout: [.leading(20), .top(0), .width(14), .height(12)])
        contentView.addSubview(stackContaierView, autoLayout: [.top(0), .bottom(12), .leadingNext(to: returnIconImageView, constant: 6), .trailing(20)])
    }
}

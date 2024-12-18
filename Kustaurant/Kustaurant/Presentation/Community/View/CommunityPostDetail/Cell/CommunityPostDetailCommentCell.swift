//
//  CommunityPostDetailCommentCell.swift
//  Kustaurant
//
//  Created by 송우진 on 11/1/24.
//

import UIKit

final class CommunityPostDetailCommentCell: DefaultCommunityPostDetailCommentCell {
    private let commentsButton: UIButton = .init()
    
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
        commentsButton.setImage(UIImage(named: "icon_comment"), for: .normal)
    }
    
    override func setupBind() {
        super.setupBind()
        commentsButton.addAction(
            UIAction { [weak self] _ in
                self?.commentsButtonTouched?(self?.commentId)
            } , for: .touchUpInside)
    }
}

extension CommunityPostDetailCommentCell {
    private func setupLayout() {
        let line = UIView()
        line.backgroundColor = .gray75
        let stackContaierView = UIView()
        let topContainerView = UIView()
        topContainerView.addSubview(rankImageView, autoLayout: [.leading(0), .fillY(0), .width(25), .height(24)])
        topContainerView.addSubview(userNicknameLabel, autoLayout: [.centerY(0), .leadingNext(to: rankImageView, constant: 4)])
        topContainerView.addSubview(line, autoLayout: [.leadingNext(to: userNicknameLabel, constant: 10), .centerY(0), .height(14), .width(1)])
        topContainerView.addSubview(timeAgoLabel, autoLayout: [.leadingNext(to: line, constant: 10), .centerY(0)])
        topContainerView.addSubview(menuEllipsisButton, autoLayout: [.centerY(0), .trailing(0), .width(20)])
        
        let bottomContainerView = UIView()
        bottomContainerView.addSubview(likeButton, autoLayout: [.leading(0), .centerY(0)])
        bottomContainerView.addSubview(dislikeButton, autoLayout: [.leadingNext(to: likeButton, constant: 12), .centerY(0)])
        bottomContainerView.addSubview(commentsButton, autoLayout: [.leadingNext(to: dislikeButton, constant: 12), .width(14), .height(15), .fillY(0)])
        
        let stackView = UIStackView(arrangedSubviews: [topContainerView, bodyLabel, bottomContainerView])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 11
        
        stackContaierView.addSubview(stackView, autoLayout: [.top(0), .fillX(0), .bottom(22)])
        contentView.addSubview(stackContaierView, autoLayout: [.fillY(0), .fillX(20)])
    }
}

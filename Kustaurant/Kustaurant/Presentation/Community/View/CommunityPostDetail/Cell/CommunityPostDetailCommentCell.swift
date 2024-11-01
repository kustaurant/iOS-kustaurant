//
//  CommunityPostDetailCommentCell.swift
//  Kustaurant
//
//  Created by 송우진 on 11/1/24.
//

import UIKit

final class CommunityPostDetailCommentCell: DefaultTableViewCell {
    private let titleLabel: UILabel = .init()
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
    
    func update(_ data: CommunityPostDTO.PostComment) {
        titleLabel.text = data.commentBody ?? "NULL"
    }
}

extension CommunityPostDetailCommentCell {
    private func setupCell() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        titleLabel.textColor = .systemBlue
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fill(0)])
    }
}

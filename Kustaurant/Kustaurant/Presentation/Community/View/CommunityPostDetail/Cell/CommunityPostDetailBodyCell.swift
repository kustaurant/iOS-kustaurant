//
//  CommunityPostDetailBodyCell.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

final class CommunityPostDetailBodyCell: UITableViewCell {
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
    
    func update(_ body: CommunityPostDetailBody) {
        print(body)
        titleLabel.text = "HI"
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
        titleLabel.textColor = .systemBlue
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fillX(26), .top(10), .bottom(10)])
    }
}

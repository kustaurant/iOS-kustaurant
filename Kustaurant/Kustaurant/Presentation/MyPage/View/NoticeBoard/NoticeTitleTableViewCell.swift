//
//  NoticeTitleTableViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/1/24.
//

import UIKit

final class NoticeTitleTableViewCell: UITableViewCell, ReusableCell {
    
    static var reuseIdentifier: String = String(describing: NoticeTitleTableViewCell.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Sementic.gray800
        label.font = .Pretendard.semiBold16
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Sementic.gray300
        label.font = .Pretendard.medium12
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoticeTitleTableViewCell {
    
    private func setupUI() {
        contentView.addSubview(titleLabel, autoLayout: [.fillX(20), .centerY(-10)])
        contentView.addSubview(createdAtLabel, autoLayout: [.fillX(20), .topNext(to: titleLabel, constant: 10)])
    }
    
    func configure(title: String?, createdAt: String?) {
        titleLabel.text = title
        createdAtLabel.text = createdAt
    }
}

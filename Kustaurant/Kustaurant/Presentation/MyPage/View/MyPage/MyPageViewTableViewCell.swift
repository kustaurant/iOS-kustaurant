//
//  MyPageViewTableViewCell.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/28/24.
//

import UIKit

final class MyPageViewTableViewCell: UITableViewCell, ReusableCell {
    
    static var reuseIdentifier: String = String(describing: MyPageViewTableViewCell.self)
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.medium16
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .Sementic.gray300
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageViewTableViewCell {
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(iconImageView, autoLayout: [.leading(20), .centerY(0), .width(20), .height(20)])
        contentView.addSubview(titleLabel, autoLayout: [.leadingNext(to: iconImageView, constant: 20), .centerY(0), .trailing(0)])
        contentView.addSubview(divider, autoLayout: [.bottom(-0.2), .fillX(0), .height(0.2)])
    }
    
    func configure(with item: MyPageTableViewItem) {
        titleLabel.text = item.title
    }
}

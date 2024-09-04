//
//  RestaurantDetailAffiliateInfoCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/11/24.
//

import UIKit

final class RestaurantDetailAffiliateInfoCell: UITableViewCell {
    
    private let titleLabel: UILabel = .init()
    private let label: UILabel = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupLabelGesture()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailAffiliateInfo else { return }
        label.text = item.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension RestaurantDetailAffiliateInfoCell {
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fillX(20), .top(0)])
        contentView.addSubview(label, autoLayout: [.fillX(20), .topNext(to: titleLabel, constant: 15), .bottom(31)])
    }
    
    private func setupStyle() {
        selectionStyle = .none
        
        titleLabel.text = "제휴 정보"
        titleLabel.font = .Pretendard.regular14
        titleLabel.textColor = .Sementic.gray800
        
        label.font = .Pretendard.medium15
        label.textColor = .Sementic.gray300
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
    }
    
    private func setupLabelGesture() {
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLabel))
        label.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapLabel() {
        if label.numberOfLines == 0 {
            label.numberOfLines = 2
            label.lineBreakMode = .byTruncatingTail
        } else {
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        if let tableView = superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

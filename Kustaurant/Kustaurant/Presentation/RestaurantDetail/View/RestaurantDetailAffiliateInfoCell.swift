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
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailAffiliateInfo else { return }
        
        label.text = item.text
    }
}

extension RestaurantDetailAffiliateInfoCell {
    
    private func setupStyle() { 
        selectionStyle = .none
        
        titleLabel.text = "제휴 정보"
        label.numberOfLines = 0
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fillX(20), .top(0)])
        contentView.addSubview(label, autoLayout: [.fillX(20), .topNext(to: titleLabel, constant: 15), .bottom(31)])
    }
}
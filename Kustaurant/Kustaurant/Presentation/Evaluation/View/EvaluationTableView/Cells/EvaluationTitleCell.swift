//
//  EvaluationTitleCell.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import UIKit

final class EvaluationTitleCell: UITableViewCell {
    private let containerView: UIView = .init()
    private let cuisineTypeLabel: UILabel = .init()
    private let titleLabel: UILabel = .init()
    private let tierIconView: UIImageView = .init()
    private let addressInfoView: InfoView = .init()
    private let lineView: UIView = .init()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailTitle) {
        cuisineTypeLabel.text = "\(item.cuisineType) | \(item.restaurantPosition)"
        titleLabel.text = item.title
        addressInfoView.text = item.address
        if let tier = item.tier, tier != .unowned {
            tierIconView.image = UIImage(named: tier.iconImageName)
        }
    }
}

extension EvaluationTitleCell {
    private func setupStyle() {
        selectionStyle = .none
        
        containerView.layer.cornerCurve = .continuous
        containerView.layer.cornerRadius = 13
        containerView.clipsToBounds = true

        addressInfoView.image = .init(named: "icon_map_marker_gray")

        lineView.backgroundColor = .gray100

        tierIconView.contentMode = .scaleAspectFit
        
        cuisineTypeLabel.font = .Pretendard.regular12
        cuisineTypeLabel.textColor = .Sementic.gray600
 
        titleLabel.font = .Pretendard.bold20
        titleLabel.textColor = .Sementic.gray800
    }
    
    private func setupLayout() {
        let topSectionStackView: UIStackView = .init()
        topSectionStackView.axis = .vertical
        topSectionStackView.alignment = .fill
        topSectionStackView.spacing = 6.5
        topSectionStackView.addArrangedSubview(cuisineTypeLabel)
        topSectionStackView.addArrangedSubview(titleLabel)

        let mainStackView: UIStackView = .init()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = 19.5
        mainStackView.addArrangedSubview(topSectionStackView)
        mainStackView.addArrangedSubview(addressInfoView)

        contentView.addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addSubview(tierIconView, autoLayout: [.trailing(15), .top(23), .width(38), .height(40)])
        containerView.addSubview(mainStackView, autoLayout: [.fillX(20), .top(33)])
        contentView.addSubview(lineView, autoLayout: [.fillX(0), .height(3), .topNext(to: mainStackView, constant: 27), .bottom(23)])
    }
}

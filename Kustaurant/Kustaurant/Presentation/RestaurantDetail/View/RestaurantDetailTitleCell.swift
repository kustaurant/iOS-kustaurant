//
//  RestaurantDetailTitleCell.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class RestaurantDetailTitleCell: UITableViewCell {
    
    private let containerView: UIView = .init()
    private let cuisineTypeLabel: UILabel = .init()
    private let titleLabel: UILabel = .init()
    private let reviewCompleteIconImageView: UIImageView = .init()
    private let addressInfoView: InfoView = .init()
    private let openingHoursInfoView: InfoView = .init()
    private let goToMapNavigationLabel: UILabel = .init()
    private let lineView: UIView = .init()
    private let tierIconView: UIImageView = .init()
    
    private var placeId: Int?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
        setupGoToMapNavigationLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem) {
        guard let item = item as? RestaurantDetailTitle else { return }
        
        cuisineTypeLabel.text = "\(item.cuisineType) | \(item.restaurantPosition)"
        titleLabel.text = item.title
        reviewCompleteIconImageView.isHidden = !item.isReviewCompleted
        addressInfoView.text = item.address
        openingHoursInfoView.text = item.openingHours
        if let tier = item.tier, tier != .unowned {
            tierIconView.image = UIImage(named: tier.iconImageName)
        }
        self.placeId = item.placeId
    }
}

extension RestaurantDetailTitleCell {
    
    private func setupStyle() {
        selectionStyle = .none
        
        containerView.layer.cornerCurve = .continuous
        containerView.layer.cornerRadius = 13
        containerView.clipsToBounds = true
        reviewCompleteIconImageView.image = .init(named: "icon_check")
        reviewCompleteIconImageView.contentMode = .scaleAspectFit
        addressInfoView.image = .init(named: "icon_map_marker_gray")
        openingHoursInfoView.image = .init(named: "icon_business_hour")
        lineView.backgroundColor = .gray100
        
        tierIconView.contentMode = .scaleAspectFit
        
        cuisineTypeLabel.font = .Pretendard.regular12
        cuisineTypeLabel.textColor = .Sementic.gray600
        
        titleLabel.font = .Pretendard.bold20
        titleLabel.textColor = .Sementic.gray800
        
        let attributedString = NSMutableAttributedString(string: "네이버 지도로 이동하기")
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.font, value: UIFont.Pretendard.medium12, range: NSRange(location: 0, length: attributedString.length))
        goToMapNavigationLabel.textColor = .Signature.green100
        goToMapNavigationLabel.attributedText = attributedString
    }
    
    private func setupLayout() {
        contentView.addSubview(tierIconView, autoLayout: [.trailing(15), .top(-20), .width(38), .height(40)])
        
        let titleHStackView: UIStackView = .init()
        titleHStackView.axis = .horizontal
        titleHStackView.alignment = .center

        // Spacer 뷰 추가
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal) // Spacer가 공간을 차지하도록 설정
        
        titleHStackView.addArrangedSubview(titleLabel)
        titleHStackView.addArrangedSubview(spacerView)  // Spacer 추가
        titleHStackView.addArrangedSubview(reviewCompleteIconImageView)
        
        let topSectionStackView: UIStackView = .init()
        topSectionStackView.axis = .vertical
        topSectionStackView.alignment = .fill
        topSectionStackView.spacing = 6.5
        topSectionStackView.addArrangedSubview(cuisineTypeLabel)
        topSectionStackView.addArrangedSubview(titleHStackView)
        
        let infoStackView: UIStackView = .init()
        infoStackView.axis = .vertical
        infoStackView.alignment = .fill
        infoStackView.spacing = 6
        infoStackView.addArrangedSubview(addressInfoView)
        infoStackView.addArrangedSubview(openingHoursInfoView)
        
        let bottomSectionStackView: UIStackView = .init()
        bottomSectionStackView.axis = .vertical
        bottomSectionStackView.alignment = .fill
        bottomSectionStackView.spacing = 12
        bottomSectionStackView.addArrangedSubview(infoStackView)
        bottomSectionStackView.addArrangedSubview(goToMapNavigationLabel)
        
        let mainStackView: UIStackView = .init()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.spacing = 19.5
        mainStackView.addArrangedSubview(topSectionStackView)
        mainStackView.addArrangedSubview(bottomSectionStackView)
        
        contentView.addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addSubview(mainStackView, autoLayout: [.fillX(20), .top(33)])
        contentView.addSubview(lineView, autoLayout: [.fillX(0), .height(3), .topNext(to: mainStackView, constant: 33), .bottom(23)])
    }
    
    private func setupGoToMapNavigationLabel() {
        goToMapNavigationLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToMapNavigationLabelTapped))
        goToMapNavigationLabel.addGestureRecognizer(tapGesture)
        // MARK: - 앱 리젝 사유 ( apple map 연동 필요 ) 우선 제거.
        goToMapNavigationLabel.isHidden = true
    }

    @objc private func goToMapNavigationLabelTapped() {
        if let placeId = placeId {
            NaverMapExternalLinkService.openNaverMapOrAppStore(with: placeId)
        }
    }
}

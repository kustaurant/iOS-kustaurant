//
//  RestaurantDetailTitleCell.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class RestaurantDetailTitleCell: UITableViewCell {
    
    private let cuisineTypeLabel: UILabel = .init()
    private let titleLabel: UILabel = .init()
    private let reviewCompleteIconImageView: UIImageView = .init()
    private let addressInfoView: InfoView = .init()
    private let openingHoursInfoView: InfoView = .init()
    private let goToMapNavigationLabel: UILabel = .init()
    private let lineView: UIView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
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
    }
}

extension RestaurantDetailTitleCell {
    
    private func setupStyle() {
        selectionStyle = .none
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = 13
        clipsToBounds = true
        reviewCompleteIconImageView.image = .init(named: "icon_check")
        reviewCompleteIconImageView.contentMode = .scaleAspectFit
        addressInfoView.image = .init(named: "icon_map_marker_gray")
        openingHoursInfoView.image = .init(named: "icon_business_hour")
        lineView.backgroundColor = .gray100
        
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
        let titleHStackView: UIStackView = .init()
        titleHStackView.axis = .horizontal
        titleHStackView.alignment = .center
        titleHStackView.addArrangedSubview(titleLabel)
        titleHStackView.addArrangedSubview(reviewCompleteIconImageView)
        
        let topSectionStackView: UIStackView = .init()
        topSectionStackView.axis = .vertical
        topSectionStackView.alignment = .leading
        topSectionStackView.spacing = 6.5
        topSectionStackView.addArrangedSubview(cuisineTypeLabel)
        topSectionStackView.addArrangedSubview(titleHStackView)
        
        let infoStackView: UIStackView = .init()
        infoStackView.axis = .vertical
        infoStackView.alignment = .leading
        infoStackView.spacing = 6
        infoStackView.addArrangedSubview(addressInfoView)
        infoStackView.addArrangedSubview(openingHoursInfoView)
        
        let bottomSectionStackView: UIStackView = .init()
        bottomSectionStackView.axis = .vertical
        bottomSectionStackView.alignment = .leading
        bottomSectionStackView.spacing = 12
        bottomSectionStackView.addArrangedSubview(infoStackView)
        bottomSectionStackView.addArrangedSubview(goToMapNavigationLabel)
        
        
        let mainStackView: UIStackView = .init()
        mainStackView.axis = .vertical
        mainStackView.alignment = .leading
        mainStackView.spacing = 19.5
        mainStackView.addArrangedSubview(topSectionStackView)
        mainStackView.addArrangedSubview(bottomSectionStackView)
        
        contentView.addSubview(mainStackView, autoLayout: [.fillX(20), .top(33)])
        contentView.addSubview(lineView, autoLayout: [.fillX(0), .height(3), .topNext(to: mainStackView, constant: 33), .bottom(23)])
    }
}

final fileprivate class InfoView: UIView {
    
    private let iconImageView: UIImageView = .init()
    private let label: UILabel = .init()
    
    var image: UIImage? {
        didSet {
            iconImageView.image = image
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(image: UIImage?, text: String?) {
        self.init(frame: .zero)
        
        self.image = image
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        label.font = .Pretendard.medium15
        label.textColor = .Sementic.gray300
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func setupLayout() {
        addSubview(iconImageView, autoLayout: [.centerY(0), .leading(0), .width(15), .height(15)])
        addSubview(label, autoLayout: [.leadingNext(to: iconImageView, constant: 6), .top(0), .bottom(0), .trailing(0)])
    }
}

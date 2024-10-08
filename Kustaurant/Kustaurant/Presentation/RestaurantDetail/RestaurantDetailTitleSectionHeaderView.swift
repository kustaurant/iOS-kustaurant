//
//  RestaurantDetailTitleSectionHeaderView.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

final class RestaurantDetailTitleSectionHeaderView: UITableViewHeaderFooterView {
    
    private let cuisineTypeLabel: UILabel = .init()
    private let titleLabel: UILabel = .init()
    private let reviewCompleteIconImageView: UIImageView = .init()
    private let addressInfoView: InfoView = .init()
    private let openingHoursInfoView: InfoView = .init()
    private let goToMapNavigationLabel: UILabel = .init()
    private let lineView: UIView = .init()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(cuisineType: String, title: String, isReviewCompleted: Bool, address: String, openingHours: String, mapURL: URL?) {
        cuisineTypeLabel.text = cuisineType
        titleLabel.text = title
        reviewCompleteIconImageView.isHidden = !isReviewCompleted
        addressInfoView.text = address
        openingHoursInfoView.text = openingHours
    }
}

extension RestaurantDetailTitleSectionHeaderView {
    
    private func setupStyle() {
        reviewCompleteIconImageView.image = .init(systemName: "person.fill")
        addressInfoView.image = .init(systemName: "person.fill")
        openingHoursInfoView.image = .init(systemName: "person.fill")
        lineView.backgroundColor = .gray100
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
        
        addSubview(mainStackView, autoLayout: [.fillX(20), .top(33)])
        addSubview(lineView, autoLayout: [.fillX(0), .height(3), .topNext(to: mainStackView, constant: 33), .bottom(23)])
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
    
    private func setupStyle() { }
    
    private func setupLayout() {
        addSubview(iconImageView, autoLayout: [.centerY(0), .leading(0), .width(15), .height(15)])
        addSubview(label, autoLayout: [.leadingNext(to: iconImageView, constant: 6), .top(0), .bottom(0), .trailing(0)])
    }
}

//
//  HomeCategoriesSection.swift
//  Kustaurant
//
//  Created by 송우진 on 8/4/24.
//

import UIKit

final class HomeCategoriesSection: UITableViewCell, ReusableCell {
    static let reuseIdentifier = String(describing: HomeCategoriesSection.self)
    static let sectionHeight: CGFloat = 424.0
    static let sectionBottomInset: CGFloat = 53.0
    
    let collectionView = HomeCategoriesCollectionView()
    
    private let sectionType: HomeSection = .categories
    private let titleLabel = UILabel()
    
    // MARK: - Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCategoriesSection {
    private func setupUI() {
        contentView.addSubview(titleLabel, autoLayout: [.top(0), .leading(20), .height(44)])
        contentView.addSubview(collectionView, autoLayout: [.topNext(to: titleLabel, constant: 7), .fillX(0), .bottom(0)])
        configureLabels()
    }
    
    private func configureLabels() {
        titleLabel.textColor = .textBlack
        titleLabel.font = .Pretendard.bold20
        titleLabel.text = sectionType.titleText()
    }
}

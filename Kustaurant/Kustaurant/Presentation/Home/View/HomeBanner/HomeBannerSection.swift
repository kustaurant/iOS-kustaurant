//
//  HomeBannerSection.swift
//  Kustaurant
//
//  Created by 송우진 on 8/15/24.
//

import UIKit

final class HomeBannerSection: UITableViewCell, ReusableCell {
    static let reuseIdentifier = String(describing: HomeBannerSection.self)
    static let sectionHeight: CGFloat = 137.0
    static let sectionBottomInset: CGFloat = 16.0
    
    let collectionView = HomeBannerCollectionView()
    var timer: Timer?
    var currentIndex: Int = 0
    
    // MARK: - Initialization
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.mainGreen
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeBannerSection {
    private func setupUI() {
        contentView.addSubview(collectionView, autoLayout: [.fill(0)])
    }
}

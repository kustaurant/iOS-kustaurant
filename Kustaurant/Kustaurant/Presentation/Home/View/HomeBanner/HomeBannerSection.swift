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
    static let sectionTopInset: CGFloat = 16.0
    
    private let pageLabel = UILabel()
    var bannersCount: Int? { didSet { bindCount() } }
    let collectionView = HomeBannerCollectionView()
    
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
    private func bindCount() {
        guard let bannersCount = bannersCount else { return }
        pageLabel.isHidden = (bannersCount <= 1)
        updateCurrentIndex(1)
    }
    
    func updateCurrentIndex(_ count: Int) {
        guard let bannersCount = bannersCount else { return }
        pageLabel.text = "\(count)/\(bannersCount)"
    }
}

extension HomeBannerSection {
    private func setupUI() {
        addSubviews()
        configurePageLabel()
    }
    
    private func addSubviews() {
        contentView.addSubview(collectionView, autoLayout: [.fill(0)])
        contentView.addSubview(pageLabel, autoLayout: [.trailing(11), .bottom(23), .width(43), .height(23)])
    }
    
    private func configurePageLabel() {
        pageLabel.isHidden = true
        pageLabel.textColor = .gray300
        pageLabel.textAlignment = .center
        pageLabel.backgroundColor = .gray800
        pageLabel.font = .Pretendard.regular12
        pageLabel.layer.cornerRadius = 11
        pageLabel.clipsToBounds = true
    }
}

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

        let pageIndexPath = (bannersCount > 1 ) ? IndexPath(item: 1, section: 0) : IndexPath(item: 0, section: 0)
        updatePageLabel(for: pageIndexPath)
        updateCollectionViewScrollToItem()
    }
    

    func updatePageLabel(for indexPath: IndexPath) {
        guard let bannersCount = bannersCount else { return }
        var currentPage = indexPath.item
        if currentPage == 0 {
            currentPage = bannersCount
        } else if currentPage == bannersCount + 1 {
            currentPage = 1
        } else {
            currentPage -= 1
        }
        pageLabel.text = "\(currentPage + 1)/\(bannersCount)"
    }
    
    private func updateCollectionViewScrollToItem() {
        guard bannersCount ?? 0 > 1 else { return }
        Task {
            await MainActor.run {
                let initialIndexPath = IndexPath(item: 1, section: 0)
                collectionView.scrollToItem(at: initialIndexPath, at: .centeredHorizontally, animated: false)
            }
        }
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

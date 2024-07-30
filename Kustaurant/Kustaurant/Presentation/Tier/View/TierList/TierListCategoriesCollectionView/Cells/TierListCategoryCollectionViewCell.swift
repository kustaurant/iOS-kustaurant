//
//  TierListCategoryCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/25/24.
//

import UIKit

final class TierListCategoryCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: TierListCategoryCollectionViewCell.self)
    static var horizontalPadding: CGFloat = 13
    var model: Category? { didSet { bind() }}
    private var label = PaddedLabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierListCategoryCollectionViewCell {
    private func bind() {
        guard let category = model else { return }
        label.setCategoryStyle(category, textInsets: UIEdgeInsets(top: 0, left: Self.horizontalPadding, bottom: 0, right: Self.horizontalPadding))
    }
}

extension TierListCategoryCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

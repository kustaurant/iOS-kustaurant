//
//  TierCategoryCollectionViewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 7/25/24.
//

import UIKit

final class TierCategoryCollectionViewCell: UICollectionViewCell, ReusableCell {
    static var reuseIdentifier: String = String(describing: TierCategoryCollectionViewCell.self)
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

extension TierCategoryCollectionViewCell {
    private func bind() {
        guard let category = model else { return }
        
        label.text = category.displayName
        label.textColor = category.isSelect ? .mainGreen : .categoryOff
        label.layer.borderColor = category.isSelect ? UIColor.mainGreen.cgColor : UIColor.categoryOff.cgColor
        label.backgroundColor = category.isSelect ? .categoryOn : .clear
    }
}

extension TierCategoryCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(label, autoLayout: [.center(0), .height(Category.height)])
        configureLabel()
    }
    
    private func configureLabel() {
        label.font = .Pretendard.regular14
        label.textAlignment = .center
        label.layer.borderWidth = 0.7
        label.layer.cornerRadius = 16

        label.textInsets = UIEdgeInsets(top: 0, left: Self.horizontalPadding, bottom: 0, right: Self.horizontalPadding)
        label.clipsToBounds = true
    }
    
}

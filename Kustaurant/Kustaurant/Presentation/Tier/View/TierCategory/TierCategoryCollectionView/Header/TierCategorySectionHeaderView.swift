//
//  TierCategorySectionHeaderView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/31/24.
//

import UIKit

final class TierCategorySectionHeaderView: UICollectionReusableView {
    static var reuseIdentifier: String = String(describing: TierCategorySectionHeaderView.self)
    static var height: CGFloat = 44
    private let title = UILabel()
    var model: CategoryType? { didSet { bind() }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TierCategorySectionHeaderView {
    private func bind() {
        title.text = model?.rawValue
    }
}

extension TierCategorySectionHeaderView {
    private func setupUI() {
        addSubviews()
        setupConstraints()
        setupTitle()
    }
    
    private func addSubviews() {
        [title].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupTitle() {
        title.textColor = .textBlack
        title.font = UIFont.Pretendard.semiBold17
    }
}

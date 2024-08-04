//
//  KuTabBarCollectionViewCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/3/24.
//

import UIKit

protocol KuTabBarCollectionViewCellable: UICollectionViewCell {
    func configure(title: String, isSelected: Bool)
}

class KuTabBarCollectionViewCell: UICollectionViewCell, KuTabBarCollectionViewCellable {
    
    private let titleLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.font = .Pretendard.regular14
    }
    
    private func setupStyle() {
        titleLabel.textAlignment = .center
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fill(20)])
    }
}

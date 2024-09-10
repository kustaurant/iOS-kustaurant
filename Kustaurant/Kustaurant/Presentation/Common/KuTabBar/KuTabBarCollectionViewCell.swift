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
    private let line: UIView = .init()
    
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
        line.backgroundColor = isSelected ? .green100 : .gray100
    }
    
    private func setupStyle() {
        titleLabel.textAlignment = .center
        titleLabel.font = .Pretendard.regular14
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fill(20)])
        contentView.addSubview(line, autoLayout: [.fillX(0), .bottom(0), .height(2)])
    }
}

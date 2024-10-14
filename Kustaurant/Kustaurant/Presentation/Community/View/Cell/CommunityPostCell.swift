//
//  CommunityPostCell.swift
//  Kustaurant
//
//  Created by 송우진 on 10/14/24.
//

import UIKit

final class CommunityPostCell: UICollectionViewCell {
    private let titleLabel: UILabel = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: CommunityPostDTO) {
        titleLabel.text = model.postTitle ?? "!"
    }
}

extension CommunityPostCell {
    private func setupStyle() {
        
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fill(0)])
    }
}

extension CommunityPostCell {
    static func layout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 100
        return section
    }
}

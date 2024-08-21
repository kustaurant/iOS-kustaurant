//
//  RestaurantDetailTierInfoCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/11/24.
//

import UIKit
import Combine

final class RestaurantDetailTierInfoCell: UITableViewCell {
    
    private let titleLabel: UILabel = .init()
    private let collectionView: RestaurantDetailTierCollectionView = .init()
    
    private var tiers: [RestaurantDetailTierInfo] = []
    private var tierCellHeightSubject: CurrentValueSubject<CGFloat, Never>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(item: RestaurantDetailCellItem, tierCellHeightSubject: CurrentValueSubject<CGFloat, Never>) {
        guard let item = item as? RestaurantDetailTiers else { return }
        
        self.tiers = item.tiers
        self.tierCellHeightSubject = tierCellHeightSubject
        
        Task {
            await MainActor.run {
                collectionView.reloadData()
                collectionView.layoutIfNeeded()
                updateHeight()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateHeight()
    }
    
    private func setupStyle() {
        selectionStyle = .none
        
        titleLabel.text = "티어 정보"
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel, autoLayout: [.fillX(20), .top(0)])
        contentView.addSubview(collectionView, autoLayout: [.fillX(20), .topNext(to: titleLabel, constant: 0), .bottom(31)])
    }
    
    private func updateHeight() {
        collectionView.updateHeight()
        tierCellHeightSubject?.send(titleLabel.estimatedSize.height + collectionView.collectionViewLayout.collectionViewContentSize.height + 31)
    }
}

extension RestaurantDetailTierInfoCell: UICollectionViewDelegateFlowLayout {
    
}

extension RestaurantDetailTierInfoCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as RestaurantDetailTierCell
        guard let tier = tiers[safe: indexPath.row] else { return cell }
        cell.update(item: tier)
        
        return cell
    }
}

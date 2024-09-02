//
//  RestuarantDetailTierInfoCell.swift
//  Kustaurant
//
//  Created by 류연수 on 8/11/24.
//

import UIKit

final class RestuarantDetailTierInfoCell: UITableViewCell {
    
    private let collectionView: RestaurantDetailTierCollectionView = .init()
    
    private var tiers: [RestaurantDetailTierCell.Tier] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(tiers: [RestaurantDetailTierCell.Tier]) {
        self.tiers = tiers
        
        Task {
            await MainActor.run {
                collectionView.reloadData()
            }
        }
    }
    
    private func setupStyle() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupLayout() {
        contentView.addSubview(collectionView, autoLayout: [.fillX(20), .top(15), .bottom(31)])
    }
}

extension RestuarantDetailTierInfoCell: UICollectionViewDelegateFlowLayout {
    
}

extension RestuarantDetailTierInfoCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as RestaurantDetailTierCell
        guard let tier = tiers[safe: indexPath.row] else { return cell }
        cell.update(tier: tier)
        
        return cell
    }
}

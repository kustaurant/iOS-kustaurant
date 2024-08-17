//
//  HomeBannerCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 8/17/24.
//

import UIKit

final class HomeBannerCollectionViewHandler: NSObject {
    private var view: HomeBannerSection
    private var viewModel: HomeViewModel
    
    init(
        view: HomeBannerSection,
        viewModel: HomeViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setup()
    }
}

extension HomeBannerCollectionViewHandler {
    private func setup() {
        view.collectionView.dataSource = self
    }
    
    func reload() {
        view.collectionView.reloadData()
    }
}

extension HomeBannerCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.banners.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HomeBannerCollectionViewCell
        cell.banner = viewModel.banners[indexPath.row]
        return cell
    }
    
}

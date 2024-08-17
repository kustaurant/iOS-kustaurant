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
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
    }
    
    func reload() {
        view.collectionView.reloadData()
    }
}

extension HomeBannerCollectionViewHandler: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 페이징이 끝났을 때 현재 페이지를 계산하여 업데이트
        let currentIndex = Int(scrollView.contentOffset.x / view.collectionView.frame.width) + 1
        view.updateCurrentIndex(currentIndex)
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

extension HomeBannerCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: HomeBannerSection.sectionTopInset,
            left: 0,
            bottom: HomeBannerSection.sectionBottomInset,
            right: 0
        )
    }
}

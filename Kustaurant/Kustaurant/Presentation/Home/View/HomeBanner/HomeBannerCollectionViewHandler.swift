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
        guard viewModel.banners.count > 1 else { return } // 데이터가 1개면 페이징 처리 없음

        let currentIndex = Int(scrollView.contentOffset.x / view.collectionView.frame.width)
        let visibleIndexPath = IndexPath(item: currentIndex, section: 0)

        // 첫 번째 더미 셀에서 마지막 아이템으로 이동
        if visibleIndexPath.item == 0 {
            let newIndexPath = IndexPath(item: viewModel.banners.count, section: 0)
            view.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
            view.updatePageLabel(for: newIndexPath)
        }

        // 마지막 더미 셀에서 첫 번째 아이템으로 이동
        else if visibleIndexPath.item == viewModel.banners.count + 1 {
            let newIndexPath = IndexPath(item: 1, section: 0)
            view.collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
            view.updatePageLabel(for: newIndexPath)
        } else {
            view.updatePageLabel(for: visibleIndexPath)
        }
    }
}

extension HomeBannerCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.banners.count > 1 ? viewModel.banners.count + 2 : viewModel.banners.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HomeBannerCollectionViewCell
        
        var dataIndex = indexPath.item
        if viewModel.banners.count > 1 {
            if dataIndex == 0 {
                dataIndex = viewModel.banners.count - 1 // 첫 번째 더미 셀
            } else if dataIndex == viewModel.banners.count + 1 {
                dataIndex = 0 // 마지막 더미 셀
            } else {
                dataIndex -= 1
            }
        }

        cell.banner = viewModel.banners[dataIndex]
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

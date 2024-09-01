//
//  HomeBannerCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 8/17/24.
//

import UIKit
import Combine

final class HomeBannerCollectionViewHandler: NSObject {
    private var view: HomeBannerSection
    private var viewModel: HomeViewModel
    private var autoScrollCancellable: AnyCancellable?

    init(
        view: HomeBannerSection,
        viewModel: HomeViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setup()
        startAutoScroll()
    }
    
    deinit {
        stopAutoScroll()
    }
}

extension HomeBannerCollectionViewHandler {
    private func setup() {
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
    }
    
    func reload() {
        view.collectionView.reloadData()
        stopAutoScroll()
        startAutoScroll()
    }
}

// Auto Scroll
extension HomeBannerCollectionViewHandler {
    private func startAutoScroll() {
        autoScrollCancellable = Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.autoScrollToNext()
            }
    }
    
    private func stopAutoScroll() {
        autoScrollCancellable?.cancel()
    }
    
    private func autoScrollToNext() {
        guard viewModel.banners.count > 1 else { return }

        let currentOffset = view.collectionView.contentOffset.x
        let nextOffset = currentOffset + view.collectionView.frame.width
        let maxOffset = view.collectionView.frame.width * CGFloat(viewModel.banners.count + 1)

        if nextOffset >= maxOffset {
            let firstIndexPath = IndexPath(item: 1, section: 0)
            view.collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
            view.updatePageLabel(for: firstIndexPath)
        } else {
            let nextIndexPath = IndexPath(item: Int(nextOffset / view.collectionView.frame.width), section: 0)
            view.collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            view.updatePageLabel(for: nextIndexPath)
        }
    }
}

extension HomeBannerCollectionViewHandler: UIScrollViewDelegate {
    // 스크롤을 시작
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }

    // 스크롤이 끝난 후
    func scrollViewDidEndDragging(
        _ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        if !decelerate {
            startAutoScroll()
        }
    }

    // 스크롤 감속이 끝났을 때
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard viewModel.banners.count > 1 else { return } // 데이터가 1개면 페이징 처리 없음
        startAutoScroll()
        
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

//
//  TierListCategoriesCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 7/25/24.
//

import UIKit

final class TierListCategoriesCollectionViewHandler: NSObject {
    private var view: TierListView
    private var viewModel: TierListViewModel
    
    // MARK: - Initialization
    init(
        view: TierListView,
        viewModel: TierListViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        
        setupCollectionView()
    }
}
extension TierListCategoriesCollectionViewHandler {
    private func setupCollectionView() {
        view.categoriesCollectionView.delegate = self
        view.categoriesCollectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate
extension TierListCategoriesCollectionViewHandler: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension TierListCategoriesCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TierListCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? TierListCategoryCollectionViewCell else { return UICollectionViewCell() }

        var model = viewModel.categories[indexPath.row]
        model.isSelect = true
        cell.model = model
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TierListCategoriesCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let category = viewModel.categories[indexPath.row]
        let label = UILabel()
        label.text = category.displayName
        label.font = .Pretendard.regular14
        let size = label.intrinsicContentSize
        return CGSize(width: size.width + (TierListCategoryCollectionViewCell.horizontalPadding * 2), height: Category.Height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        7
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 7)
    }
}

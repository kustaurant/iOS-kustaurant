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
        view.topCategoriesView.categoriesCollectionView.delegate = self
        view.topCategoriesView.categoriesCollectionView.dataSource = self
    }
    
    func reloadData() {
        Task {
            await MainActor.run {
                view.topCategoriesView.categoriesCollectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TierListCategoriesCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.filteredCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TierCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? TierCategoryCollectionViewCell else { return UICollectionViewCell() }

        var model = viewModel.filteredCategories[indexPath.row]
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
        let category = viewModel.filteredCategories[indexPath.row]
        let label = UILabel()
        label.text = category.displayName
        label.font = .Pretendard.regular14
        let size = label.intrinsicContentSize
        return CGSize(width: size.width + (TierCategoryCollectionViewCell.horizontalPadding * 2), height: Category.height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 7)
    }
}

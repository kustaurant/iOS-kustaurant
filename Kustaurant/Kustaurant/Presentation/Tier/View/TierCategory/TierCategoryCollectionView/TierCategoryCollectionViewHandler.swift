//
//  TierCategoryCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 7/31/24.
//
import UIKit

final class TierCategoryCollectionViewHandler: NSObject {
    private var view: TierCategoryView
    private var viewModel: TierCategoryViewModel
    
    // MARK: - Initialization
    init(
        view: TierCategoryView,
        viewModel: TierCategoryViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        
        setupCollectionView()
    }
}

extension TierCategoryCollectionViewHandler {
    private func setupCollectionView() {
        view.categoriesCollectionView.delegate = self
        view.categoriesCollectionView.dataSource = self
    }
    
    private func getCategory(for indexPath: IndexPath) -> Category {
        switch CategoryType.allCases[indexPath.section] {
        case .cuisine:
            return viewModel.cuisines[indexPath.item]
        case .situation:
            return viewModel.situations[indexPath.item]
        case .location:
            return viewModel.locations[indexPath.item]
        }
    }
    
    func reloadSection(indexSet: IndexSet) {
        Task {
            await MainActor.run {
                view.categoriesCollectionView.reloadSections(indexSet)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TierCategoryCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let category = getCategory(for: indexPath)
        viewModel.selectCategories(categories: [category])
    }
}

// MARK: - UICollectionViewDataSource
extension TierCategoryCollectionViewHandler: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CategoryType.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TierCategorySectionHeaderView.reuseIdentifier, for: indexPath) as? TierCategorySectionHeaderView else { return UICollectionReusableView() }
        let categoryType = CategoryType.allCases[indexPath.section]
        header.model = categoryType
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch CategoryType.allCases[section] {
        case .cuisine:
            return viewModel.cuisines.count
        case .situation:
            return viewModel.situations.count
        case .location:
            return viewModel.locations.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TierListCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? TierListCategoryCollectionViewCell else { return UICollectionViewCell() }
        let category = getCategory(for: indexPath)
        cell.model = category
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TierCategoryCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let category = getCategory(for: indexPath)
        let label = UILabel()
        label.text = category.displayName
        label.font = .pretendard(size: 14, weight: .regular)
        let size = label.intrinsicContentSize
        return CGSize(width: size.width + (TierListCategoryCollectionViewCell.horizontalPadding * 2), height: Category.Height)
    }
}

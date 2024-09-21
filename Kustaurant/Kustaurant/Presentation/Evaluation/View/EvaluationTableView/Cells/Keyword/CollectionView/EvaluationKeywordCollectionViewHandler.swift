//
//  EvaluationKeywordCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 9/10/24.
//

import UIKit

final class EvaluationKeywordCollectionViewHandler: NSObject {
    private var view: EvaluationKeywordCell
    private var viewModel: EvaluationViewModel
    
    
    // MARK: - Initialization
    init(
        view: EvaluationKeywordCell,
        viewModel: EvaluationViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setupCollectionView()
    }
}


extension EvaluationKeywordCollectionViewHandler {
    private func setupCollectionView() {
        view.keywrodsCollectionView.delegate = self
        view.keywrodsCollectionView.dataSource = self
    }
    
    func reload() {
        view.keywrodsCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate
extension EvaluationKeywordCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let keyword = viewModel.situations[indexPath.item]
        viewModel.selectKeyword(keyword: keyword)
    }
}

// MARK: - UICollectionViewDataSource
extension EvaluationKeywordCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.situations.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: TierCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.model = viewModel.situations[indexPath.item]
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EvaluationKeywordCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let category = viewModel.situations[indexPath.item]
        let label = UILabel()
        label.text = category.displayName
        label.font = UIFont.Pretendard.regular14
        let size = label.intrinsicContentSize
        return CGSize(width: size.width + (TierCategoryCollectionViewCell.horizontalPadding * 2), height: Category.height)
    }
}

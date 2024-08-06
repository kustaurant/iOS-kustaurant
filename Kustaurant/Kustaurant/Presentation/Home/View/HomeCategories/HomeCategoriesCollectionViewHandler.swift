//
//  HomeCategoriesCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 8/6/24.
//

import UIKit

final class HomeCategoriesCollectionViewHandler: NSObject {
    private var view: HomeCategoriesSection
    private var viewModel: HomeViewModel
    
    init(
        view: HomeCategoriesSection,
        viewModel: HomeViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setup()
    }
}

extension HomeCategoriesCollectionViewHandler {
    private func setup() {
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
    }
}

extension HomeCategoriesCollectionViewHandler: UICollectionViewDelegate {

}

extension HomeCategoriesCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.cuisines.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HomeCategoriesCollectionViewCell
        cell.cuisine = viewModel.cuisines[indexPath.row]
        return cell
    }
    
}

extension HomeCategoriesCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: HomeCategoriesSection.sectionBottomInset, right: 20)
    }
}

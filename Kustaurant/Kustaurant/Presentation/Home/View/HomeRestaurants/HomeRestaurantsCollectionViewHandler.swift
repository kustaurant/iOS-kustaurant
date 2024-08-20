//
//  HomeRestaurantsCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 8/5/24.
//

import UIKit

final class HomeRestaurantsCollectionViewHandler: NSObject {
    private var view: HomeRestaurantsSection
    private var viewModel: HomeViewModel
    
    init(
        view: HomeRestaurantsSection,
        viewModel: HomeViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setup()
    }
}

extension HomeRestaurantsCollectionViewHandler {
    private func setup() {
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
    }

    func reload() {
        view.collectionView.reloadData()
    }
    
    private func sectionDatas() -> [Restaurant] {
        switch sectionType() {
        case .topRestaurants:
            return viewModel.topRestaurants
        case .forMeRestaurants:
            return viewModel.forMeRestaurants
        default: return []
        }
    }
    
    private func sectionType() -> HomeSection? {
        let parentCell = view.collectionView.superview?.superview as? HomeRestaurantsSection
        return parentCell?.sectionType
    }
}

// MARK: - Actions
extension HomeRestaurantsCollectionViewHandler {
    private func restaurantListsDidSelect(_ restaurant: Restaurant) {
        viewModel.restaurantListsDidSelect(restaurant: restaurant)
    }
}

extension HomeRestaurantsCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let restaurant = sectionDatas()[indexPath.row]
        restaurantListsDidSelect(restaurant)
    }
}

extension HomeRestaurantsCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        sectionDatas().count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as HomeRestaurantsCollectionViewCell
        cell.model = sectionDatas()[indexPath.row]
        return cell
    }
    
}

extension HomeRestaurantsCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: 191, height: 196)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: HomeRestaurantsSection.sectionBottomInset, right: 20)
    }
}

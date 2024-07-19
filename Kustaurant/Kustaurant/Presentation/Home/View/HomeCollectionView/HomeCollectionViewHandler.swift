//
//  HomeCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import UIKit

enum HomeSection: Int {
    case banner = 0
    case categories = 1
    case topRestaurants = 2
    case forMeRestaurants = 3
}

final class HomeCollectionViewHandler: NSObject {
    private var view: HomeView
    private var viewModel: HomeViewModel
    
    // MARK: - Initialization
    init(
        view: HomeView,
        viewModel: HomeViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setupMainCollectionView()
    }
}

extension HomeCollectionViewHandler {
    private func setupMainCollectionView() {
        view.mainCollectionView.delegate = self
        view.mainCollectionView.dataSource = self
    }
    
    private func isMainCollectionView(_ collectionView: UICollectionView) -> Bool {
        collectionView == view.mainCollectionView
    }
    
    func reloadData() async {
        await MainActor.run {
            view.mainCollectionView.reloadData()
        }
    }

    func reloadSections(_ sections: IndexSet) async {
        await MainActor.run {
            view.mainCollectionView.reloadSections(sections)
        }
    }
}

// MARK: - Actions
extension HomeCollectionViewHandler {
    private func restaurantListsMoreButtonTapped(type: HomeSection) {
        print("\(type.rawValue)")
    }
    
    private func restaurantlistsDidSelect(
        _ sectionType: HomeSection,
        indexPath: IndexPath
    ) {
        let restaurant = (sectionType == .topRestaurants) ? viewModel.topRestaurants[indexPath.row] : viewModel.forMeRestaurants[indexPath.row]
        viewModel.restaurantlistsDidSelect(restaurant: restaurant)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if !isMainCollectionView(collectionView) {
            if let parentCell = collectionView.superview?.superview as? HomeMainCollectionViewCell,
               let sectionType = parentCell.sectionType {
                restaurantlistsDidSelect(sectionType, indexPath: indexPath)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == view.mainCollectionView {
            return viewModel.mainSections.count
        } else {
            return 1
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if isMainCollectionView(collectionView) {
            return 1
        } else {
            guard let cell = collectionView.superview?.superview as? HomeMainCollectionViewCell,
                  let sectionType = cell.sectionType else { return 0 }
            switch sectionType {
            case .topRestaurants:
                return viewModel.topRestaurants.count
            case .forMeRestaurants:
                return viewModel.forMeRestaurants.count
            default:
                return 0
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if isMainCollectionView(collectionView) {
            guard let sectionType = HomeSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch sectionType {
            case .topRestaurants, .forMeRestaurants:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMainCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeMainCollectionViewCell else { return UICollectionViewCell() }
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.collectionView.allowsSelection = true
                cell.moreButton.addAction( UIAction { [weak self] _ in self?.restaurantListsMoreButtonTapped(type: sectionType)}, for: .touchUpInside)
                cell.updateAndReload(section: sectionType)
                return cell
            default:
                let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: indexPath)
                defaultCell.backgroundColor = .systemPink
                return defaultCell
            }
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRestaurantListsCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeRestaurantListsCollectionViewCell else { return UICollectionViewCell() }
            
            if let parentCell = collectionView.superview?.superview as? HomeMainCollectionViewCell,
               let sectionType = parentCell.sectionType {
                switch sectionType {
                case .topRestaurants:
                    cell.updateContent(viewModel.topRestaurants[indexPath.row])
                case .forMeRestaurants:
                    cell.updateContent(viewModel.forMeRestaurants[indexPath.row])
                default: break
                }
            }
            return cell
            
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if isMainCollectionView(collectionView) {
            UIEdgeInsets(top: 0, left: 0, bottom: 53, right: 0)
        } else {
            UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        isMainCollectionView(collectionView) ? 0 : 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if isMainCollectionView(collectionView) {
            guard let section = HomeSection(rawValue: indexPath.section) else {
                return CGSize(width: collectionView.bounds.width, height: 0.1)
            }
            switch section {
            case .banner: return CGSize(width: collectionView.bounds.width, height: 55)
            case .categories: return CGSize(width: collectionView.bounds.width, height: 55)
            case .topRestaurants:
                return CGSize(width: collectionView.bounds.width, height: viewModel.topRestaurants.isEmpty ? 0 : 261)
            case .forMeRestaurants: 
                return CGSize(width: collectionView.bounds.width, height: viewModel.forMeRestaurants.isEmpty ? 0 : 261)
            }
        } else {
            return CGSize(width: 191, height: 196)
        }
    }
}

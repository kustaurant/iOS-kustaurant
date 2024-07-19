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
    
    func updateAndReloadSection(_ section: HomeSection) {
        let indexSet = IndexSet(integer: section.rawValue)
        view.mainCollectionView.reloadSections(indexSet)
    }
}

// MARK: - Actions
extension HomeCollectionViewHandler {
    private func restaurantListsMoreButtonTapped(type: HomeSection) {
        print("\(type.rawValue)")
    }
}

// MARK: - UICollectionViewDelegate
extension HomeCollectionViewHandler: UICollectionViewDelegate {
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
        if collectionView == view.mainCollectionView {
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
            let defaultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Default", for: indexPath)
            defaultCell.backgroundColor = .systemPink
            
            guard let sectionType = HomeSection(rawValue: indexPath.section) else { return defaultCell }

            switch sectionType {
            case .topRestaurants, .forMeRestaurants:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMainCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeMainCollectionViewCell else { return UICollectionViewCell() }
                cell.collectionView.delegate = self
                cell.collectionView.dataSource = self
                cell.moreButton.addAction( UIAction { [weak self] _ in self?.restaurantListsMoreButtonTapped(type: sectionType)}, for: .touchUpInside)
                cell.updateAndReload(section: sectionType)
                return cell
            default:
                return defaultCell
            }
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeRestaurantListsCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeRestaurantListsCollectionViewCell else { return UICollectionViewCell() }

            if let sectionType = HomeSection(rawValue: indexPath.section) {
                cell.updateCell(section: sectionType)
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
                return CGSize(width: collectionView.bounds.width, height: 0)
            }
            switch section {
            case .banner: return CGSize(width: collectionView.bounds.width, height: 100)
            case .categories: return CGSize(width: collectionView.bounds.width, height: 100)
            case .topRestaurants: return CGSize(width: collectionView.bounds.width, height: 261)
            case .forMeRestaurants: return CGSize(width: collectionView.bounds.width, height: 261)
            }
        } else {
            return CGSize(width: 191, height: 196)
        }
    }
}

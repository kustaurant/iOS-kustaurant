//
//  TierFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol TierFlowCoordinatorDependencies {
    func makeTierViewController(listActions: TierListViewModelActions, mapActions: TierMapViewModelActions, initialCategories: [Category]) -> TierViewController
    func makeTierCategoryViewController(actions: TierCategoryViewModelActions, categories: [Category]) -> TierCategoryViewController
    func makeTierMapBottomSheet() -> TierMapBottomSheet
}

final class TierFlowCoordinator: Coordinator {
    
    private let dependencies: TierFlowCoordinatorDependencies
    var navigationController: UINavigationController

    private weak var tierViewController: TierViewController?
    private weak var tierMapBottomSheet: TierMapBottomSheet?
    
    init(
        dependencies: TierFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension TierFlowCoordinator {
    func start() {
        start(initialCategories: [Cuisine.all.category, Situation.all.category, Location.all.category])
    }
    
    func start(initialCategories: [Category]) {
        let listActions = TierListViewModelActions(
            showTierCategory: showTierCategory
        )
        let mapActions = TierMapViewModelActions(
            showTierCategory: showTierCategory,
            showMapBottomSheet: showMapBottomSheet,
            hideMapBottomSheet: hideMapBottomSheet
        )
        let viewController = dependencies.makeTierViewController(
            listActions: listActions,
            mapActions: mapActions,
            initialCategories: initialCategories
        )
        let image = UIImage(named: TabBarPage.tier.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.tier.pageTitleValue(), image: image, selectedImage: image)
        tierViewController = viewController
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showTierCategory(categories: [Category]) {
        let actions = TierCategoryViewModelActions(
            receiveTierCategories: receiveTierCategories
        )
        let viewController = dependencies.makeTierCategoryViewController(actions: actions, categories: categories)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func receiveTierCategories(categories: [Category]) {
        if let currentViewController = tierViewController?.viewControllers?.first as? TierCategoryReceivable {
            currentViewController.receiveTierCategories(categories: categories)
        }
    }
    
    private func showMapBottomSheet(restaurant: Restaurant) {
        guard tierMapBottomSheet == nil else {
            tierMapBottomSheet?.configure(with: restaurant)
            return
        }
        let viewController = dependencies.makeTierMapBottomSheet()
        viewController.configure(with: restaurant)
        tierMapBottomSheet = viewController
        navigationController.present(viewController, animated: true)
    }
    
    private func hideMapBottomSheet() {
        tierMapBottomSheet?.dismiss(animated: true, completion: nil)
        tierMapBottomSheet = nil
    }
    
}

//
//  TierFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol TierFlowCoordinatorDependencies {
    func makeTierViewController(actions: TierListViewModelActions, initialCategories: [Category]) -> TierViewController
    func makeTierCategoryViewController(actions: TierCategoryViewModelActions, categories: [Category]) -> TierCategoryViewController
}

final class TierFlowCoordinator: Coordinator {
    
    private let dependencies: TierFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    private weak var tierListViewController: TierListViewController?
    
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
        let actions = TierListViewModelActions(
            showTierCategory: showTierCategory
        )
        let viewController = dependencies.makeTierViewController(actions: actions, initialCategories: initialCategories)
        let image = UIImage(named: TabBarPage.tier.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.tier.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: true)
        tierListViewController = viewController.pages.first as? TierListViewController
    }
    
    private func showTierCategory(categories: [Category]) {
        let actions = TierCategoryViewModelActions(
            receiveTierCategories: receiveTierCategories
        )
        let viewController = dependencies.makeTierCategoryViewController(actions: actions, categories: categories)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func receiveTierCategories(categories: [Category]) {
        tierListViewController?.receiveTierCategories(categories: categories)
    }
}

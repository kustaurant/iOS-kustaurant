//
//  TierFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol TierFlowCoordinatorDependencies {
    func makeTierViewController(actions: TierListViewModelActions) -> TierViewController
    func makeTierCategoryViewController() -> TierCategoryViewController
}

final class TierFlowCoordinator: Coordinator {
    private let dependencies: TierFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
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
        let actions = TierListViewModelActions(
            showTierCategory: showTierCategory
        )
        let viewController = dependencies.makeTierViewController(actions: actions)
        let image = UIImage(named: TabBarPage.tier.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.tier.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showTierCategory() {
        let viewController = dependencies.makeTierCategoryViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

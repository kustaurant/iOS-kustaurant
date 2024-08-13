//
//  RecommendFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol DrawFlowCoordinatorDependencies {
    func makeDrawViewController(actions: DrawViewModelActions) -> DrawViewController
    func makeDrawResultViewController(actions: DrawResultViewModelActions, locations: [Location], cuisines: [Cuisine]) -> DrawResultViewController
}

final class DrawFlowCoordinator: Coordinator {
    private let dependencies: DrawFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: DrawFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension DrawFlowCoordinator {
    func start() {
        let actions = DrawViewModelActions(didTapDrawButton: didTapDrawButton)
        let viewController = dependencies.makeDrawViewController(actions: actions)
        let image = UIImage(named: TabBarPage.draw.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.draw.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func didTapDrawButton(locations: [Location], cuisines: [Cuisine]) {
        let actions = DrawResultViewModelActions(didTapBackButton: popAnimated)
        let viewController = dependencies.makeDrawResultViewController(
            actions: actions,
            locations: locations,
            cuisines: cuisines
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popAnimated() {
        pop(animated: true)
    }
}

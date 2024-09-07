//
//  RestaurantDetailFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

protocol RestaurantDetailFlowCoordinatorDependencies {
    func makeRestaurantDetailViewController(with id: Int, actions: RestaurantDetailViewModelActions) -> RestaurantDetailViewController
}

final class RestaurantDetailFlowCoordinator: Coordinator {
    
    private let appDIContainer: AppDIContainer
    private let dependencies: RestaurantDetailFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        appDIContainer: AppDIContainer,
        dependencies: RestaurantDetailFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {}
}

extension RestaurantDetailFlowCoordinator {
    func start(id: Int) {
        let actions = RestaurantDetailViewModelActions(
            pop: popAnimated,
            showEvaluateScene: showEvaluateScene,
            showSearchScene: showSearchScene
        )
        let viewController = dependencies.makeRestaurantDetailViewController(with: id, actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func popAnimated() {
        pop(animated: true)
    }
    
    private func showEvaluateScene() {
        let diContainer = appDIContainer.makeEvaluationDIContainer()
        let coordinator = diContainer.makeEvaluationFlowCoordianator(navigationController: navigationController)
        coordinator.start()
    }
    
    func showSearchScene() {
        let searchDIContainer = appDIContainer.makeSearchDIContainer()
        let searchFlow = searchDIContainer.makeSearchFlowCoordinator(
            appDIContainer: appDIContainer,
            navigationController: navigationController,
            rootNavigationController: navigationController
        )
        searchFlow.start()
    }
}

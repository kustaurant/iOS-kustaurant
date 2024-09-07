//
//  RecommendFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol DrawFlowCoordinatorDependencies {
    func makeDrawViewController(actions: DrawViewModelActions) -> DrawViewController
    func makeDrawResultViewController(actions: DrawResultViewModelActions, restaurants: [Restaurant]) -> DrawResultViewController
}

final class DrawFlowCoordinator: Coordinator {
    private let appDIContainer: AppDIContainer
    private let dependencies: DrawFlowCoordinatorDependencies
    var navigationController: UINavigationController
    var rootNavigationController: UINavigationController
    
    init(
        appDIContainer: AppDIContainer,
        dependencies: DrawFlowCoordinatorDependencies,
        navigationController: UINavigationController,
        rootNavigationController: UINavigationController
    ) {
        self.appDIContainer = appDIContainer
        self.dependencies = dependencies
        self.navigationController = navigationController
        self.rootNavigationController = rootNavigationController
    }
}

extension DrawFlowCoordinator {
    func start() {
        let actions = DrawViewModelActions(
            didTapDrawButton: didTapDrawButton,
            didTapSearchButton: showSearch
        )
        let viewController = dependencies.makeDrawViewController(actions: actions)
        let image = UIImage(named: TabBarPage.draw.pageImageName() + "_off")?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: TabBarPage.draw.pageImageName() + "_on")?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(
            title: TabBarPage.draw.pageTitleValue(),
            image: image,
            selectedImage: selectedImage
        )
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func didTapDrawButton(restaurants: [Restaurant]) {
        let actions = DrawResultViewModelActions(
            didTapBackButton: popAnimated,
            didTapSearchButton: showSearch,
            showRestaurantDetails: showRestaurantDetail
        )
        let viewController = dependencies.makeDrawResultViewController(
            actions: actions,
            restaurants: restaurants
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popAnimated() {
        pop(animated: true)
    }
    
    func showSearch() {
        let searchDIContainer = appDIContainer.makeSearchDIContainer()
        let searchFlow = searchDIContainer.makeSearchFlowCoordinator(navigationController: navigationController)
        searchFlow.start()
    }
    
    private func showRestaurantDetail(restaurantId: Int) {
        let restaurantDetailSceneDIContainer = appDIContainer.makeRestaurantDetailSceneDIContainer()
        let flow = restaurantDetailSceneDIContainer.makeRestaurantDetailFlowCoordinator(
            navigationController: rootNavigationController
        )
        flow.start(id: restaurantId)
    }
}

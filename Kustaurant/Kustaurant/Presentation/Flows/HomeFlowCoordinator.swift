//
//  HomeFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController
}

final class HomeFlowCoordinator: Coordinator {
    private let dependencies: HomeFlowCoordinatorDependencies
    private let appDIContainer: AppDIContainer
    var navigationController: UINavigationController
    var rootNavigationController: UINavigationController
    
    init(
        dependencies: HomeFlowCoordinatorDependencies,
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController,
        rootNavigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
        self.rootNavigationController = rootNavigationController
    }
}

extension HomeFlowCoordinator {
    func start() {
        let actions = HomeViewModelActions(
            showRestaurantDetail: showRestaurantDetail,
            showTierScene: showTierScene
        )
        let viewController = dependencies.makeHomeViewController(actions: actions)
        let image = UIImage(named: TabBarPage.home.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.home.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showRestaurantDetail(restaurant: Restaurant) {
        let restaurantDetailSceneDIContainer = appDIContainer.makeRestaurantDetailSceneDIContainer()
        let flow = restaurantDetailSceneDIContainer.makeRestaurantDetailFlowCoordinator(
            navigationController: rootNavigationController
        )
        flow.start()
    }
    
    private func showTierScene(cuisine: Cuisine) {
        let tierDIContainer = appDIContainer.makeTierSceneDIContainer()
        let tierFlow = tierDIContainer.makeTierFlowCoordinator(
            navigationController: navigationController
        )
        tierFlow.start(initialCategories: [
            cuisine.category,
            Situation.all.category,
            Location.all.category
        ])
    }
}

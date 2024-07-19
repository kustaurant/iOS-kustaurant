//
//  RestaurantDetailSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

final class RestaurantDetailSceneDIContainer: RestaurantDetailFlowCoordinatorDependencies {
    func makeRestaurantDetailViewController() -> RestaurantDetailViewController {
        RestaurantDetailViewController()
    }

    func makeRestaurantDetailFlowCoordinator(navigationController: UINavigationController) -> RestaurantDetailFlowCoordinator {
        RestaurantDetailFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

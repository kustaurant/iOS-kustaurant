//
//  RestaurantDetailSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

final class RestaurantDetailSceneDIContainer: RestaurantDetailFlowCoordinatorDependencies {
    func makeRestaurantDetailViewController(with id: Int) -> RestaurantDetailViewController {
        RestaurantDetailViewController(viewModel: .init(repository: DefaultRestaurantDetailRepository(networkService: .init(), restaurantID: id)))
    }

    func makeRestaurantDetailFlowCoordinator(navigationController: UINavigationController) -> RestaurantDetailFlowCoordinator {
        RestaurantDetailFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

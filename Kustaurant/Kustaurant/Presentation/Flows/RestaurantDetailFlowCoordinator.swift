//
//  RestaurantDetailFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

protocol RestaurantDetailFlowCoordinatorDependencies {
    func makeRestaurantDetailViewController() -> RestaurantDetailViewController
}

final class RestaurantDetailFlowCoordinator: Coordinator {
    private let dependencies: RestaurantDetailFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: RestaurantDetailFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension RestaurantDetailFlowCoordinator {
    func start() {
        let viewController = dependencies.makeRestaurantDetailViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

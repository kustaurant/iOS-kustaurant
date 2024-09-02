//
//  RestaurantDetailFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

protocol RestaurantDetailFlowCoordinatorDependencies {
    func makeRestaurantDetailViewController(with id: Int) -> RestaurantDetailViewController
}

final class RestaurantDetailFlowCoordinator {
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
    func start(id: Int) {
        let viewController = dependencies.makeRestaurantDetailViewController(with: id)
        navigationController.pushViewController(viewController, animated: true)
    }
}

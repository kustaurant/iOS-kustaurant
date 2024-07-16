//
//  HomeSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    func makeHomeViewController() -> HomeViewController {
        HomeViewController()
    }
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        HomeFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

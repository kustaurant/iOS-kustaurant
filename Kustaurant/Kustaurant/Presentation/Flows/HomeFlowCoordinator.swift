//
//  HomeFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol HomeFlowCoordinatorDependencies {
    func makeHomeViewController() -> HomeViewController
}

final class HomeFlowCoordinator: Coordinator {
    private let dependencies: HomeFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: HomeFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension HomeFlowCoordinator {
    func start() {
        let viewController = dependencies.makeHomeViewController()
        let image = UIImage(named: TabBarPage.home.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.home.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
}

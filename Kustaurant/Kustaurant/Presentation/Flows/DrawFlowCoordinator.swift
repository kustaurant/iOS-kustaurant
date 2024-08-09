//
//  RecommendFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol DrawFlowCoordinatorDependencies {
    func makeDrawViewController() -> DrawViewController
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
        let viewController = dependencies.makeDrawViewController()
        let image = UIImage(named: TabBarPage.draw.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.draw.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
}

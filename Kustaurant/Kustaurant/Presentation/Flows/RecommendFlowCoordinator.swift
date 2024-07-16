//
//  RecommendFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol RecommendFlowCoordinatorDependencies {
    func makeRecommendViewController() -> RecommendViewController
}

final class RecommendFlowCoordinator: Coordinator {
    private let dependencies: RecommendFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: RecommendFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension RecommendFlowCoordinator {
    func start() {
        let viewController = dependencies.makeRecommendViewController()
        let image = UIImage(named: TabBarPage.recommend.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.recommend.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
}

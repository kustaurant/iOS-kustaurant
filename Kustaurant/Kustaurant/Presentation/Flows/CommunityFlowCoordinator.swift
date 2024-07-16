//
//  CommunityFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol CommunityFlowCoordinatorDependencies {
    func makeCommunityViewController() -> CommunityViewController
}

final class CommunityFlowCoordinator: Coordinator {
    private let dependencies: CommunityFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: CommunityFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension CommunityFlowCoordinator {
    func start() {
        let viewController = dependencies.makeCommunityViewController()
        let image = UIImage(named: TabBarPage.community.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.community.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
}

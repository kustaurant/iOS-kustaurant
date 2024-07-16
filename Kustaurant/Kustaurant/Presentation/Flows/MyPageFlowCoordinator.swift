//
//  MyPageFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol MyPageFlowCoordinatorDependencies {
    func makeMyPageViewController() -> MyPageViewController
}

final class MyPageFlowCoordinator: Coordinator {
    private let dependencies: MyPageFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: MyPageFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension MyPageFlowCoordinator {
    func start() {
        let viewController = dependencies.makeMyPageViewController()
        let image = UIImage(named: TabBarPage.mypage.pageImageName())?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(title: TabBarPage.mypage.pageTitleValue(), image: image, selectedImage: image)
        navigationController.pushViewController(viewController, animated: false)
    }
}

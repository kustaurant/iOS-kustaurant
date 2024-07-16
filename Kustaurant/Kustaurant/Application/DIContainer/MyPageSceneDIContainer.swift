//
//  MyPageSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController()
    }
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        MyPageFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

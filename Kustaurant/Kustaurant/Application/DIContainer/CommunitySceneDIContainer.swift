//
//  CommunitySceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class CommunitySceneDIContainer: CommunityFlowCoordinatorDependencies {
    func makeCommunityViewController() -> CommunityViewController {
        CommunityViewController()
    }
    
    func makeCommunityFlowCoordinator(navigationController: UINavigationController) -> CommunityFlowCoordinator {
        CommunityFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

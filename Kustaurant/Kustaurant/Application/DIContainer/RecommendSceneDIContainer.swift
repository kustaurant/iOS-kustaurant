//
//  RecommendSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class RecommendSceneDIContainer: RecommendFlowCoordinatorDependencies {
    func makeRecommendViewController() -> RecommendViewController {
        RecommendViewController()
    }
    
    func makeRecommendFlowCoordinator(navigationController: UINavigationController) -> RecommendFlowCoordinator {
        RecommendFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

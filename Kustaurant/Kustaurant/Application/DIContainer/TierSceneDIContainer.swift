//
//  TierSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class TierSceneDIContainer: TierFlowCoordinatorDependencies {
    func makeTierViewModel() -> TierViewModel {
        DefaultTierViewModel()
    }
    func makeTierViewController() -> TierViewController {
        TierViewController(
            viewModel: makeTierViewModel()
        )
    }
    
    func makeTierFlowCoordinator(navigationController: UINavigationController) -> TierFlowCoordinator {
        TierFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

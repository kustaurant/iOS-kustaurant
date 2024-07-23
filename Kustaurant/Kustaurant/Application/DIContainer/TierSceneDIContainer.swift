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
    
    func makeTierListViewModel() -> TierListViewModel {
        DefaultTierListViewModel()
    }
    
    func makeTierListViewController() -> TierListViewController {
        TierListViewController(
            viewModel: makeTierListViewModel()
        )
    }
    
    func makeTierMapViewController() -> TierMapViewController {
        TierMapViewController()
    }
    
    func makeTierViewController() -> TierViewController {
        TierViewController(
            tierListViewController: makeTierListViewController(),
            TierMapViewController: makeTierMapViewController()
        )
    }
    
    func makeTierFlowCoordinator(navigationController: UINavigationController) -> TierFlowCoordinator {
        TierFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

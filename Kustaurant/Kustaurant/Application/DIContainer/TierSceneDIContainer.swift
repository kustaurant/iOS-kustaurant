//
//  TierSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class TierSceneDIContainer: TierFlowCoordinatorDependencies {
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeTierRepository() -> TierRepository {
        DefaultTierRepository(
            networkService: dependencies.networkService
        )
    }
    
    func makeTierUseCase() -> TierUseCases {
        DefaultTierUseCases(
            tierRepository: makeTierRepository()
        )
    }
    
    func makeTierListViewModel() -> TierListViewModel {
        DefaultTierListViewModel(
            tierUseCase: makeTierUseCase()
        )
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

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
    
    func makeTierCategoryViewModel(categories: [Category]) -> TierCategoryViewModel {
        DefaultTierCategoryViewModel(
            categories: categories
        )
    }
    
    func makeTierCategoryViewController(categories: [Category]) -> TierCategoryViewController {
        TierCategoryViewController(
            viewModel: makeTierCategoryViewModel(categories: categories)
        )
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
    
    func makeTierListViewModel(actions: TierListViewModelActions) -> TierListViewModel {
        DefaultTierListViewModel(
            tierUseCase: makeTierUseCase(),
            actions: actions
        )
    }
    
    func makeTierListViewController(actions: TierListViewModelActions) -> TierListViewController {
        TierListViewController(
            viewModel: makeTierListViewModel(actions: actions)
        )
    }
    
    func makeTierMapViewController() -> TierMapViewController {
        TierMapViewController()
    }
    
    func makeTierViewController(actions: TierListViewModelActions) -> TierViewController {
        TierViewController(
            tierListViewController: makeTierListViewController(actions: actions),
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

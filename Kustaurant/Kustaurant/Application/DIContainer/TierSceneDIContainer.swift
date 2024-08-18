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
    
    func makeTierCategoryViewModel(
        actions: TierCategoryViewModelActions,
        categories: [Category]
    ) -> TierCategoryViewModel {
        DefaultTierCategoryViewModel(
            actions: actions,
            categories: categories
        )
    }
    
    func makeTierCategoryViewController(
        actions: TierCategoryViewModelActions,
        categories: [Category]
    ) -> TierCategoryViewController {
        TierCategoryViewController(
            viewModel: makeTierCategoryViewModel(actions: actions, categories: categories)
        )
    }
    
    func makeTierRepository() -> TierRepository {
        DefaultTierRepository(
            networkService: dependencies.networkService
        )
    }
    
    func makeTierMapRepository() -> TierMapRepository {
        DefaultTierMapRepository(
            networkService: dependencies.networkService
        )
    }
    
    func makeTierUseCase() -> TierUseCases {
        DefaultTierUseCases(
            tierRepository: makeTierRepository()
        )
    }
    

    func makeTierMapUseCase() -> TierMapUseCases {
        DefaultTierMapUseCases(
            tierMapRepository: makeTierMapRepository()
        )
    }
    

    func makeTierListViewModel(
        actions: TierListViewModelActions,
        initialCategories: [Category]
    ) -> TierListViewModel {
        DefaultTierListViewModel(
            tierUseCase: makeTierUseCase(),
            actions: actions,
            initialCategories: initialCategories
        )
    }
    
    func makeTierListViewController(
        actions: TierListViewModelActions,
        initialCategories: [Category]
    ) -> TierListViewController {
        TierListViewController(
            viewModel: makeTierListViewModel(actions: actions, initialCategories: initialCategories)
        )
    }
    
    func makeTierMpaViewModel(initialCategories: [Category]) -> TierMapViewModel {
        DefaultTierMapViewModel(
            tierUseCase: makeTierUseCase(),
            tierMapUseCase: makeTierMapUseCase(),
            initialCategories: initialCategories
        )
    }
    
    func makeTierMapViewController(initialCategories: [Category]) -> TierMapViewController {
        TierMapViewController(
            viewModel: makeTierMpaViewModel(initialCategories: initialCategories)
        )
    }
    
    func makeTierViewController(
        actions: TierListViewModelActions,
        initialCategories: [Category]
    ) -> TierViewController {
        TierViewController(
            tierListViewController: makeTierListViewController(actions: actions, initialCategories: initialCategories),
            TierMapViewController: makeTierMapViewController(initialCategories: initialCategories)
        )
    }
    
    func makeTierFlowCoordinator(navigationController: UINavigationController) -> TierFlowCoordinator {
        TierFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

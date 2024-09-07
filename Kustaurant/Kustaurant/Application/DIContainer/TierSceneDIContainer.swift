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
    
    func makeTierMpaViewModel(
        actions: TierMapViewModelActions,
        initialCategories: [Category]
    ) -> TierMapViewModel {
        DefaultTierMapViewModel(
            tierUseCase: makeTierUseCase(),
            tierMapUseCase: makeTierMapUseCase(),
            actions: actions,
            initialCategories: initialCategories
        )
    }
    
    func makeTierMapViewController(
        actions: TierMapViewModelActions,
        initialCategories: [Category]
    ) -> TierMapViewController {
        TierMapViewController(
            viewModel: makeTierMpaViewModel(actions: actions, initialCategories: initialCategories)
        )
    }
    
    func makeTierMapBottomSheet() -> TierMapBottomSheet {
        TierMapBottomSheet()
    }
    
    func makeTierViewController(
        listActions: TierListViewModelActions,
        mapActions: TierMapViewModelActions,
        initialCategories: [Category]
    ) -> TierViewController {
        TierViewController(
            tierListViewController: makeTierListViewController(actions: listActions, initialCategories: initialCategories),
            TierMapViewController: makeTierMapViewController(actions: mapActions, initialCategories: initialCategories)
        )
    }
    
    func makeTierFlowCoordinator(
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController,
        rootNavigationController: UINavigationController
    ) -> TierFlowCoordinator {
        TierFlowCoordinator(
            dependencies: self,
            appDIContainer: appDIContainer,
            navigationController: navigationController,
            rootNavigationController: rootNavigationController
        )
    }
}

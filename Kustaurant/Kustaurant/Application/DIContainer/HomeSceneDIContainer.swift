//
//  HomeSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class HomeSceneDIContainer: HomeFlowCoordinatorDependencies {
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeViewController(actions: HomeViewModelActions) -> HomeViewController {
        HomeViewController(
            viewModel: makeHomeViewModel(actions: actions)
        )
    }
    
    func makeHomeViewModel(actions: HomeViewModelActions) -> HomeViewModel {
        DefaultHomeViewModel(
            homeUseCase: makeHomeUseCase(), 
            actions: actions
        )
    }
    
    func makeHomeRepository() -> HomeRepository {
        DefaultHomeRepository(
            networkService: dependencies.networkService
        )
    }
    
    func makeHomeUseCase() -> HomeUseCases {
        DefaultHomeUseCases(
            homeRepository: makeHomeRepository()
        )
    }
    
    func makeHomeFlowCoordinator(
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController,
        rootNavigationControler: UINavigationController
    ) -> HomeFlowCoordinator {
        HomeFlowCoordinator(
            dependencies: self,
            appDIContainer: appDIContainer,
            navigationController: navigationController,
            rootNavigationController: rootNavigationControler
        )
    }
}

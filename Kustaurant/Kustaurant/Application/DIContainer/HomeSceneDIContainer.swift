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
    
    func makeHomeViewController() -> HomeViewController {
        HomeViewController(
            viewModel: makeHomeViewModel()
        )
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        DefaultHomeViewModel(
            homeUseCase: makeHomeUseCase()
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
    
    func makeHomeFlowCoordinator(navigationController: UINavigationController) -> HomeFlowCoordinator {
        HomeFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

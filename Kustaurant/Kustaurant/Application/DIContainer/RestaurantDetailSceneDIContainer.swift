//
//  RestaurantDetailSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

final class RestaurantDetailSceneDIContainer: RestaurantDetailFlowCoordinatorDependencies {
    
    struct Dependencies {
        let appDIContainer: AppDIContainer
        let networkService: NetworkService
    }
    
    private let dependencies: RestaurantDetailSceneDIContainer.Dependencies
    
    init(dependencies: RestaurantDetailSceneDIContainer.Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeRestaurantDetailViewController(with id: Int, actions: RestaurantDetailViewModelActions) -> RestaurantDetailViewController {
        RestaurantDetailViewController(viewModel: makeRestaurantDetailViewModel(with: id, actions: actions))
    }
    
    func makeRestaurantDetailViewModel(with id: Int, actions: RestaurantDetailViewModelActions) -> RestaurantDetailViewModel {
        RestaurantDetailViewModel(restaurantId: id, actions: actions, repository: makeRestaurantDetailRepository(with: id), authRepository: makeAuthRepository())
    }
    
    func makeRestaurantDetailRepository(with id: Int) -> RestaurantDetailRepository {
        DefaultRestaurantDetailRepository(networkService: dependencies.networkService, restaurantID: id)
    }

    func makeRestaurantDetailFlowCoordinator(navigationController: UINavigationController) -> RestaurantDetailFlowCoordinator {
        RestaurantDetailFlowCoordinator(
            appDIContainer: dependencies.appDIContainer,
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository(networkService: dependencies.networkService)
    }
}

//
//  CommunitySceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class CommunitySceneDIContainer: CommunityFlowCoordinatorDependencies {
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeCommunityRepository() -> CommunityRepository {
        DefaultCommunityRepository(
            networkService: dependencies.networkService
        )
    }
    
    func makeCommunityUseCase() -> CommunityUseCases {
        DefaultCommunityUseCases(
            communityRepository: makeCommunityRepository()
        )
    }
    
    func makeCommunityViewModel() -> CommunityViewModel {
        DefaultCommunityViewModel(
            communityUseCase: makeCommunityUseCase()
        )
    }
    
    func makeCommunityViewController() -> CommunityViewController {
        CommunityViewController(
            viewModel: makeCommunityViewModel()
        )
    }
    
    func makeCommunityFlowCoordinator(navigationController: UINavigationController) -> CommunityFlowCoordinator {
        CommunityFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

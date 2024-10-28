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
    
    func makeCommunityFlowCoordinator(navigationController: UINavigationController) -> CommunityFlowCoordinator {
        CommunityFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

// Main
extension CommunitySceneDIContainer {
    func makeCommunityViewModel(actions: CommunityViewModelActions) -> CommunityViewModel {
        DefaultCommunityViewModel(
            communityUseCase: makeCommunityUseCase(),
            actions: actions
        )
    }
    
    func makeCommunityViewController(actions: CommunityViewModelActions) -> CommunityViewController {
        CommunityViewController(
            viewModel: makeCommunityViewModel(actions: actions)
        )
    }
}


// Post Detail
extension CommunitySceneDIContainer {
    func makeCommunityPostDetailViewModel() -> CommunityPostDetailViewModel {
        DefaultCommunityPostDetailViewModel(
            communityUseCase: makeCommunityUseCase()
        )
    }
    func makeCommunityPostDetailViewController() -> CommunityPostDetailViewController {
        CommunityPostDetailViewController(
            viewModel: makeCommunityPostDetailViewModel()
        )
    }
}

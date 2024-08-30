//
//  MyPageSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class MyPageSceneDIContainer: MyPageFlowCoordinatorDependencies {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeMyPageViewController(actions: MyPageViewModelActions) -> MyPageViewController {
        MyPageViewController(viewModel: makeMyPageViewModel(actions: actions))
    }
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        MyPageFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeMyPageViewModel(actions: MyPageViewModelActions) -> MyPageViewModel {
        DefaultMyPageViewModel(
            actions: actions,
            authUseCases: makeAuthUseCases(),
            myPageUseCases: makeMyPageUseCases()
        )
    }
    
    func makeAuthUseCases() -> AuthUseCases {
        DefaultAuthUseCases(
            naverLoginService: makeNaverLoginService(),
            appleLoginService: makeAppleLoginService(),
            socialLoginUserRepository: makeSocialLoginUserRepository(),
            authReposiory: makeAuthRepository()
        )
    }
    
    func makeNaverLoginService() -> NaverLoginService {
        NaverLoginService(networkService: dependencies.networkService)
    }
    
    func makeSocialLoginUserRepository() -> SocialLoginUserRepository {
        DefaultSocialLoginUserRepository()
    }
    
    func makeAppleLoginService() -> AppleLoginService {
        AppleLoginService()
    }
    
    func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository(networkService: dependencies.networkService)
    }
    
    func makeMyPageRepository() -> MyPageRepository {
        DefaultMyPageRepository(networkService: dependencies.networkService)
    }
    
    func makeMyPageUseCases() -> MyPageUseCases {
        DefaultMyPageUseCases(myPageRepository: makeMyPageRepository())
    }
        
    func makeProfileComposeViewController(actions: ProfileComposeViewModelActions) -> ProfileComposeViewController {
        ProfileComposeViewController(viewModel: makeProfileComposeViewModel(actions: actions))
    }
    
    func makeSavedRestaurantsViewController(actions: SavedRestaurantsViewModelActions) -> SavedRestaurantsViewController {
        SavedRestaurantsViewController(viewModel: makeSavedRestaurantsViewModel(actions: actions))
    }
        
    func makeFeedbackSubmittingViewController(actions: FeedbackSubmittingViewModelActions) -> FeedbackSubmittingViewController {
        FeedbackSubmittingViewController(viewModel: makeFeedbackSubmittingViewModel(actions: actions))
    }
}

extension MyPageSceneDIContainer {

    func makeProfileComposeViewModel(actions: ProfileComposeViewModelActions) -> ProfileComposeViewModel {
        DefaultProfileComposeViewModel(actions: actions)
    }
    
    func makeSavedRestaurantsViewModel(actions: SavedRestaurantsViewModelActions) -> SavedRestaurantsViewModel {
        DefaultSavedRetaurantsViewModel(actions: actions, myPageUseCases: makeMyPageUseCases())
    }
    
    func makeFeedbackSubmittingViewModel(actions: FeedbackSubmittingViewModelActions) -> FeedbackSubmittingViewModel {
        DefaultFeedbackSubmittingViewModel(actions: actions, myPageUseCases: makeMyPageUseCases())
    }
}

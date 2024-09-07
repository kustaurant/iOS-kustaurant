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
    
    func makeMyPageFlowCoordinator(appDIContainer: AppDIContainer, navigationController: UINavigationController) -> MyPageFlowCoordinator {
        MyPageFlowCoordinator(
            dependencies: self,
            appDIContainer: appDIContainer,
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
        
    func makeProfileComposeViewController(actions: ProfileComposeViewModelActions, profileImgUrl: String?) -> ProfileComposeViewController {
        ProfileComposeViewController(viewModel: makeProfileComposeViewModel(actions: actions, profileImgUrl: profileImgUrl))
    }
    
    func makeSavedRestaurantsViewController(actions: SavedRestaurantsViewModelActions) -> SavedRestaurantsViewController {
        SavedRestaurantsViewController(viewModel: makeSavedRestaurantsViewModel(actions: actions))
    }
        
    func makeFeedbackSubmittingViewController(actions: FeedbackSubmittingViewModelActions) -> FeedbackSubmittingViewController {
        FeedbackSubmittingViewController(viewModel: makeFeedbackSubmittingViewModel(actions: actions))
    }
    
    func makeNoticeBoardViewController(actions: NoticeBoardViewModelActions) -> NoticeBoardViewController {
        NoticeBoardViewController(viewModel: makeNoticeBoardViewModel(actions: actions))
    }

    func makeTermsOfServiceViewController(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> TermsOfServiceViewController {
        TermsOfServiceViewController(viewModel: makeWebViewLoadViewModel(webViewUrl: webViewUrl, actions: actions))
    }
    
    func makePrivacyPolicyViewController(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> PrivacyPolicyViewController {
        PrivacyPolicyViewController(viewModel: makeWebViewLoadViewModel(webViewUrl: webViewUrl, actions: actions))
    }
}

extension MyPageSceneDIContainer {
    
    func makeNoticeBoardViewModel(actions: NoticeBoardViewModelActions) -> NoticeBoardViewModel {
        DefaultNoticeBoardViewModel(actions: actions, myPageUseCases: makeMyPageUseCases())
    }

    func makeProfileComposeViewModel(actions: ProfileComposeViewModelActions, profileImgUrl: String?) -> ProfileComposeViewModel {
        DefaultProfileComposeViewModel(actions: actions, myPageUseCases: makeMyPageUseCases(), profileImgUrl: profileImgUrl)
    }
    
    func makeSavedRestaurantsViewModel(actions: SavedRestaurantsViewModelActions) -> SavedRestaurantsViewModel {
        DefaultSavedRetaurantsViewModel(actions: actions, myPageUseCases: makeMyPageUseCases())
    }
    
    func makeFeedbackSubmittingViewModel(actions: FeedbackSubmittingViewModelActions) -> FeedbackSubmittingViewModel {
        DefaultFeedbackSubmittingViewModel(actions: actions, myPageUseCases: makeMyPageUseCases())
    }
    
    func makeWebViewLoadViewModel(webViewUrl: String, actions: PlainWebViewLoadViewModelActions) -> PlainWebViewLoadViewModel {
        DefaultPlainWebViewLoadViewModel(webViewUrl: webViewUrl, actions: actions)
    }
}

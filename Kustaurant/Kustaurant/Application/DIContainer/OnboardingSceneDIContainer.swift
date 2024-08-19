//
//  OnboardingSceneDIContainer.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

final class OnboardingSceneDIContainer: OnboardingFlowCoordinatorDependencies {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeOnboardingFlowCoordinator(navigationController: UINavigationController) -> OnboardingFlowCoordinator {
        OnboardingFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> OnboardingViewController {
        OnboardingViewController(viewModel: makeOnboardingViewModel(actions: actions))
    }
    
    func makeLoginViewController(actions: OnboardingViewModelActions) -> LoginViewController {
        LoginViewController(viewModel: makeOnboardingViewModel(actions: actions))
    }
    
    func makeOnboardingViewModel(actions: OnboardingViewModelActions) -> OnboardingViewModel {
        DefaultOnboardingViewModel(
            actions: actions,
            onboardingUseCases: makeOnboardingUseCases()
        )
    }
    
    func makeOnboardingUseCases() -> OnboardingUseCases {
        DefaultOnboardingUseCases(
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
        DefaultSocialLoginUserRepository(keychainStorage: makeKeychaingStorage())
    }
    
    func makeKeychaingStorage() -> KeychainStorage {
        KeychainStorage()
    }
    
    func makeAppleLoginService() -> AppleLoginService {
        AppleLoginService()
    }
    
    func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository(networkService: dependencies.networkService)
    }
}

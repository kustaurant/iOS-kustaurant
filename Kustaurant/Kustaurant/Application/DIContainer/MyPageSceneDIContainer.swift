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
    
    func makeMyPageViewController() -> MyPageViewController {
        MyPageViewController()
    }
    
    func makeMyPageFlowCoordinator(navigationController: UINavigationController) -> MyPageFlowCoordinator {
        MyPageFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeMyPageViewModel() -> MyPageViewModel {
        
    }
    
    func makeOnboardingUseCases() -> AuthUseCases {
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

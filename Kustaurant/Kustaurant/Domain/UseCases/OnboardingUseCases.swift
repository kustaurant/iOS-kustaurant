//
//  OnboardingUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/16/24.
//

import Foundation
import Combine

protocol OnboardingUseCases {
    func naverLogin() -> AnyPublisher<SocialLoginUser, NetworkError>
    func appleLogin() -> AnyPublisher<SocialLoginUser, Never>
    func naverLogout()
}

final class DefaultOnboardingUseCases: OnboardingUseCases {
    
    private let naverLoginService: NaverLoginService
    private let appleLoginService: AppleLoginService
    private let socialLoginUserRepository: SocialLoginUserRepository
    private let authReposiory: AuthRepository
    
    init(naverLoginService: NaverLoginService, appleLoginService: AppleLoginService, socialLoginUserRepository: SocialLoginUserRepository, authReposiory: AuthRepository) {
        self.naverLoginService = naverLoginService
        self.appleLoginService = appleLoginService
        self.socialLoginUserRepository = socialLoginUserRepository
        self.authReposiory = authReposiory
    }
}

extension DefaultOnboardingUseCases {
    
    func naverLogin() -> AnyPublisher<SocialLoginUser, NetworkError> {
        naverLoginService.attemptLogin()
            .flatMap(processNaverLogin)
            .eraseToAnyPublisher()
    }
    
    func naverLogout() {
        socialLoginUserRepository.setUser(nil)
        naverLoginService.attemptLogout()
    }
    
    func appleLogin() -> AnyPublisher<SocialLoginUser, Never> {
        appleLoginService.attemptLogin()
            .map { [weak self] response in
                let id = response.id
                let user = SocialLoginUser(id: id, accessToken: "token", provider: .apple)
                self?.socialLoginUserRepository.setUser(user)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    func appleLogout() {
        socialLoginUserRepository.setUser(nil)
    }
}

extension DefaultOnboardingUseCases {
    
    private func processNaverLogin(_ response: SignInWithNaverResponse) -> AnyPublisher<SocialLoginUser, NetworkError> {
        Future { promise in
            Task { [weak self] in
                let naverAuthResponse = await self?.authReposiory.naverLogin(userId: response.id, naverAccessToken: response.naverAccessToken)
                switch naverAuthResponse {
                case .success(let accessToken):
                    let user = SocialLoginUser(id: response.id, accessToken: accessToken, provider: .naver)
                    self?.socialLoginUserRepository.setUser(user)
                    promise(.success(user))
                case .failure(let error):
                    promise(.failure(error))
                case .none:
                    promise(.failure(.unknown))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

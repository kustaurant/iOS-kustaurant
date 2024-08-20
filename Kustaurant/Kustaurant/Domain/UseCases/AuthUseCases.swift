//
//  OnboardingUseCases.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/16/24.
//

import Foundation
import Combine

protocol AuthUseCases {
    func naverLogin() -> AnyPublisher<SocialLoginUser, NetworkError>
    func appleLogin() -> AnyPublisher<SocialLoginUser, NetworkError>
    func logout()
}

final class DefaultAuthUseCases: AuthUseCases {
    
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

extension DefaultAuthUseCases {
    
    func naverLogin() -> AnyPublisher<SocialLoginUser, NetworkError> {
        naverLoginService.attemptLogin()
            .flatMap(processNaverLogin)
            .eraseToAnyPublisher()
    }

    func appleLogin() -> AnyPublisher<SocialLoginUser, NetworkError> {
        appleLoginService.attemptLogin()
            .flatMap(processAppleLogin)
            .eraseToAnyPublisher()
    }
        
    func logout() {
        if let user = socialLoginUserRepository.getUser() {
            Task {
                await authReposiory.logout(userId: user.id)
            }
        }
        socialLoginUserRepository.setUser(nil)
        naverLoginService.attemptLogout()
    }
}

extension DefaultAuthUseCases {
    
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
    
    private func processAppleLogin(_ response: SignInWithAppleResponse) -> AnyPublisher<SocialLoginUser, NetworkError> {
        Future { promise in
            Task { [weak self] in
                let appleAuthResponse = await self?.authReposiory.appleLogin(authorizationCode: response.authorizationCode, identityToken: response.identityToken)
                switch appleAuthResponse {
                case .success(let accessToken):
                    let user = SocialLoginUser(id: response.id, accessToken: accessToken, provider: .naver)
                    self?.socialLoginUserRepository.setUser(user)
                    promise(.success(user))
                case .failure(let error):
                    promise(.failure(error))
                case .none:
                    break
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

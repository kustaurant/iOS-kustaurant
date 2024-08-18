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
    func naverLogout()
}

final class DefaultOnboardingUseCases: OnboardingUseCases {
    
    private let naverLoginService: NaverLoginService
    private let socialLoginUserRepository: SocialLoginUserRepository
    
    init(naverLoginService: NaverLoginService, socialLoginUserRepository: SocialLoginUserRepository) {
        self.naverLoginService = naverLoginService
        self.socialLoginUserRepository = socialLoginUserRepository
    }
}

extension DefaultOnboardingUseCases {
    
    func naverLogin() -> AnyPublisher<SocialLoginUser, NetworkError> {
        naverLoginService.attemptLogin()
            .map { [weak self] response in
                // TODO: 서버 api에 유저 정보 전송 및 액세스 토큰 받아서 SocialLoginUser에 세팅
                let id = response.response.id
                let user = SocialLoginUser(id: id, accessToken: "token", provider: .naver)
                self?.socialLoginUserRepository.setUser(user)
                return user
            }
            .eraseToAnyPublisher()
    }
    
    func naverLogout() {
        naverLoginService.attemptLogout()
    }
}

//
//  NaverLoginService.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/16/24.
//

import Foundation
import NaverThirdPartyLogin
import Combine


final class NaverLoginService: NSObject, LoginService {
    
    private let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let naverLoginRepository: NaverLoginRepository
    let userPublisher = PassthroughSubject<SocialLoginUser, NetworkError>()
    
    init(networkService: NetworkService) {
        self.naverLoginRepository = NaverLoginRepository(networkService: networkService)
        super.init()
        naverLoginInstance?.delegate = self
    }
    
    func attemptLogin() -> AnyPublisher<SocialLoginUser, NetworkError> {
        naverLoginInstance?.requestThirdPartyLogin()
        return userPublisher.eraseToAnyPublisher()
    }
    
    func attemptLogout() -> Void {
        naverLoginInstance?.requestDeleteToken()
    }
}

extension NaverLoginService: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("🟢Naver Login 성공")
        let tokens = getLoginToken()
        Task {
            let result = await naverLoginRepository.me(authorization: tokens.bearerToken)
            switch result {
            case .success(let data):
                userPublisher.send(SocialLoginUser(id: data.response.id, accessToken: tokens.accessToken, provider: .naver))
            case .failure(let error):
                print(#file, #function, error.localizedDescription)
            }
        }
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        naverLoginInstance?.accessToken
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("🟢Naver Logout 성공")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("❗️Naver Login Error = \(error.localizedDescription)")
    }
    
    private func getLoginToken() -> (accessToken: String, bearerToken: String) {
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return ("", "") }

        if !isValidAccessToken {
            return ("", "")
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else { return ("", "") }
        guard let accessToken = naverLoginInstance?.accessToken else { return ("", "") }

        return (accessToken, "\(tokenType) \(accessToken)")
    }
}

extension NaverLoginService {
        
    static func configureAppDelegate() {
        guard
            let urlScheme = Bundle.main.infoDictionary?["naverLoginUrlScheme"] as? String,
            let clientId = Bundle.main.infoDictionary?["naverClientId"] as? String,
            let clientSecret = Bundle.main.infoDictionary?["naverClientSecret"] as? String else {
            print("❗️Fail to load naver client info", #file, #function)
            return
        }
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isInAppOauthEnable = true
        instance?.isNaverAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.serviceUrlScheme = urlScheme
        instance?.consumerKey = clientId
        instance?.consumerSecret = clientSecret
        instance?.appName = "쿠스토랑"
    }
    
    static func configureSceneDelegate(openURLContexts URLContexts: Set<UIOpenURLContext>) {
        NaverThirdPartyLoginConnection
            .getSharedInstance()
            .receiveAccessToken(URLContexts.first?.url)
    }
}


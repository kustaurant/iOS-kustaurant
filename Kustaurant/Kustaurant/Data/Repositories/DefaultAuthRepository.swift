//
//  DefaultAuthRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/19/24.
//

import Foundation

final class DefaultAuthRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultAuthRepository: AuthRepository {
    func appleLogin(authorizationCode: String, identityToken: String) async -> Result<String, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/apple-login", method: .post)
        urlBuilder.addHeaders(["Content-Type": "application/json"])
        
        let parameters: [String: Any] = [
            "provider": SocialLoginProvider.apple.rawValue,
            "authorizationCode": authorizationCode,
            "identityToken": identityToken
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            urlBuilder.setBody(jsonData)
        } else {
            return .failure(.invalidRequest)
        }
        
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard
            let data: AccessTokenResponse? = response.decode(),
            let accessToken = data?.accessToken
        else {
            return .failure(.decodingFailed)
        }
        
        return .success(accessToken)
    }

    func naverLogin(userId: String, naverAccessToken: String) async -> Result<String, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/naver-login", method: .post)
        
        urlBuilder.addHeaders(["Content-Type": "application/json"])
        
        let parameters: [String: Any] = [
            "provider": SocialLoginProvider.naver.rawValue,
            "providerId": userId,
            "naverAccessToken": naverAccessToken
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
            urlBuilder.setBody(jsonData)
        } else {
            return .failure(.invalidRequest)
        }
        
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard 
            let data: AccessTokenResponse? = response.decode(),
            let accessToken = data?.accessToken
        else {
            return .failure(.decodingFailed)
        }
        
        return .success(accessToken)
    }
    
    func logout(userId: String) async {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/log-out")
        urlBuilder.addQuery(parameter: ["userId": userId])
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            print(error.localizedDescription)
        }
    }
}

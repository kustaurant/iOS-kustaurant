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
        urlBuilder.addQuery(
            parameter: [
                "provider": SocialLoginProvider.apple.rawValue,
                "authorizationCode": authorizationCode,
                "identityToken": identityToken
            ]
        )
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        print(response)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: String = response.decodeString() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }

    func naverLogin(userId: String, naverAccessToken: String) async -> Result<String, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/naver-login", method: .post)
        urlBuilder.addQuery(
            parameter: [
                "provider": SocialLoginProvider.naver.rawValue,
                "providerId": userId,
                "naverAccessToken": naverAccessToken
            ]
        )
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: String = response.decodeString() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
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

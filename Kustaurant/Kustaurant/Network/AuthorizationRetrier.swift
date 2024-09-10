//
//  AuthorizationRetrier.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/27/24.
//

import Foundation

public class AuthorizationRetrier: RequestRetrier {
    
    private let interceptor: RequestInterceptor
    private let networkService: NetworkService
    
    init(interceptor: RequestInterceptor, networkService: NetworkService) {
        self.interceptor = interceptor
        self.networkService = networkService
    }
    
    public func shouldRetry(_ request: URLRequest, with error: Error, attempt: Int) -> Bool {
        return false
    }
    
    public func shouldRetryAsync(with error: Error, attempt: Int) async -> Bool {
        if attempt > 2 {
            return false
        }
        
        guard
            let error = error as? NetworkError,
            (error == .unauthorized || error == .forbidden)
        else {
            return false
        }
        
        return await refreshToken()
    }
    
    private func refreshToken() async -> Bool {
        guard let user: UserCredentials = KeychainStorage.shared.getValue(forKey: KeychainKey.userCredentials) else {
            return false
        }
        
        let url = networkService.appConfiguration.apiBaseURL + "/api/v1/new-access-token"
        let urlBuilder = URLRequestBuilder(url: url, method: .post)
        let request = Request(session: URLSession.shared, interceptor: interceptor, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            /// refreshToken API에서 valid 한 토큰을 보내면 400에러를 내려주기 때문에 토큰 갱신 완료 처리
            if error == .badRequest {
                return false
            }
            
            if error == .unauthorized || error == .forbidden {
                return true
            }
            
            Logger.error(error.localizedDescription, category: .network)
            return false
        }
        
        guard let data: AccessTokenResponse = response.decode() else {
            Logger.error("Fail to Decoding Refresh Token API", category: .network)
            return false
        }
        
        let updatedUser = UserCredentials(id: user.id, accessToken: data.accessToken, provider: user.provider)
        KeychainStorage.shared.setValue(updatedUser, forKey: KeychainKey.userCredentials)
        return true
    }
}

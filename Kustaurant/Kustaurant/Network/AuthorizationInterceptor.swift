//
//  AuthorizationInterceptor.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/26/24.
//

import Foundation

public class AuthorizationInterceptor: RequestInterceptor {

    public func intercept(_ request: URLRequest) -> URLRequest {
        guard let user: KuUser = KeychainStorage.shared.getValue(forKey: KeychainKey.kuUser) else {
            return request
        }
        var modifiedRequest = request
        modifiedRequest.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
}
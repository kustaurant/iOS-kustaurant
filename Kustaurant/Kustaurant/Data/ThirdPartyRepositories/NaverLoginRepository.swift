//
//  NaverAPIRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/17/24.
//

import Foundation

final class NaverLoginRepository {
    
    let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension NaverLoginRepository {
    
    func me(authorization: String) async -> Result<NaverMeResponse, NetworkError> {
        var urlBuilder = URLRequestBuilder(url: "https://openapi.naver.com/v1/nid/me")
        urlBuilder.addHeaders(["Authorization": authorization])
        
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: NaverMeResponse = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
}

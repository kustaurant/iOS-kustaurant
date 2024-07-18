//
//  DefaultHomeRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Foundation

final class DefaultHomeRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultHomeRepository: HomeRepository {
    
    // 네트워크 관련 코드 정리 필요
    func fetchRestaurantLists() async -> Result<HomeRestaurantLists, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/home")
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: HomeRestaurantLists = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
}

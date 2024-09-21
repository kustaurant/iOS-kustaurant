//
//  DefaultEvaluationRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import Foundation

final class DefaultEvaluationRepository: EvaluationRepository {
    
    private let networkService: NetworkService
    private let restaurantID: Int
    
    init(
        networkService: NetworkService,
        restaurantID: Int
    ) {
        self.networkService = networkService
        self.restaurantID = restaurantID
    }
}

extension DefaultEvaluationRepository {
    func fetch() async -> Result<EvaluationDTO, NetworkError> {
        let urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/auth/restaurants/\(restaurantID)/evaluation")
        let authInterceptor = AuthorizationInterceptor()
        let authRetrier = AuthorizationRetrier(interceptor: authInterceptor, networkService: networkService)
        let request = Request(session: URLSession.shared, interceptor: authInterceptor, retrier: authRetrier)
        
        let response = await request.responseAsync(with: urlBuilder)
        if let error = response.error {
            return .failure(error)
        }
        guard let data: EvaluationDTO = response.decode() else {
            return .failure(.decodingFailed)
        }
        return .success(data)
    }
}

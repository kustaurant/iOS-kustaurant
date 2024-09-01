//
//  DefaultDrawRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/13/24.
//

import Foundation

final class DefaultDrawRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultDrawRepository: DrawRepository {
    
    func retrieveRestaurantsBy(locations: [Location], cuisines: [Cuisine]) async -> Result<[Restaurant], NetworkError> {
        let locationsQuery = locations.map { $0.category.code }.joined(separator: ",")
        let cuisinesQuery = cuisines.map { $0.category.code }.joined(separator: ",")
        
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/draw")
        urlBuilder.addQuery(parameter: [
            "location": locationsQuery,
            "cuisines": cuisinesQuery
        ])
        
        let request = Request(session: URLSession.shared, interceptor: nil, retrier: nil)
        let response = await request.responseAsync(with: urlBuilder)
        
        if let error = response.error {
            return .failure(error)
        }
        
        guard let data: [Restaurant] = response.decode() else {
            return .failure(.decodingFailed)
        }
        
        return .success(data)
    }
}

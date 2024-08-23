//
//  DefaultSearchRepository.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation

final class DefaultSearchRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultSearchRepository: SearchRepository {
    
    func search(term: String) async -> Result<[Restaurant], NetworkError> {
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/search")
        urlBuilder.addQuery(parameter: ["kw": term])
        
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

//
//  DefaultTierRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

final class DefaultTierRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultTierRepository: TierRepository {
    func fetchTierLists(
        cuisines: [Cuisine],
        situations: [Situation],
        locations: [Location],
        ranking: Int,
        limit: Int
    ) async -> Result<[Restaurant], NetworkError> {
        let cuisineCodes = cuisines.map { $0.category.code }.joined(separator: ",")
        let situationCodes = situations.map({ $0.category.code }).joined(separator: ",")
        let locationCodes = locations.map({ $0.category.code }).joined(separator: ",")
        var urlBuilder = URLRequestBuilder(url: networkService.appConfiguration.apiBaseURL + "/api/v1/tier")
        urlBuilder.addQuery(parameter: [
            "cuisines": cuisineCodes,
            "situations": situationCodes,
            "locations": locationCodes,
            "ranking": "\(ranking)",
            "limit": "\(limit)"
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

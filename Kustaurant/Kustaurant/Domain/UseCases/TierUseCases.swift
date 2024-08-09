//
//  TierUseCases.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

protocol TierUseCases {
    func fetchTierLists(cuisines: [Cuisine], situations: [Situation], locations: [Location], page: Int) async -> Result<[Restaurant], NetworkError>
}

final class DefaultTierUseCases {
    private let tierRepository: TierRepository

    init(tierRepository: TierRepository) {
        self.tierRepository = tierRepository
    }
}

extension DefaultTierUseCases: TierUseCases {
    func fetchTierLists(
        cuisines: [Cuisine],
        situations: [Situation],
        locations: [Location],
        page: Int
    ) async -> Result<[Restaurant], NetworkError> {
        await tierRepository.fetchTierLists(cuisines: cuisines, situations: situations, locations: locations, page: page, limit: 100)
    }
}

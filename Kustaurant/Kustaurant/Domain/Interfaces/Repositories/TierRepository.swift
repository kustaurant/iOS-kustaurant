//
//  TierRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

protocol TierRepository {
    func fetchTierMap(cuisines: [Cuisine], situations: [Situation], locations: [Location]) async -> Result<TierMapRestaurants, NetworkError>
    func fetchTierLists(cuisines: [Cuisine], situations: [Situation], locations: [Location], ranking: Int, limit: Int) async -> Result<[Restaurant], NetworkError>
}

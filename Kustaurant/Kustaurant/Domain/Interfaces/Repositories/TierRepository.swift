//
//  TierRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Foundation

protocol TierRepository {
    func fetchTierLists(cuisines: [Cuisine], situations: [Situation], locations: [Location], page: Int, limit: Int) async -> Result<[Restaurant], NetworkError>
}

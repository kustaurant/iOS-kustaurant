//
//  DefaultTierMapRepository.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Foundation

final class DefaultTierMapRepository {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultTierMapRepository: TierMapRepository {
    
}

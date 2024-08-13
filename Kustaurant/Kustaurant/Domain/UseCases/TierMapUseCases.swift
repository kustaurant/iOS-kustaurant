//
//  TierMapUseCases.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Foundation

protocol TierMapUseCases {
    
}

final class DefaultTierMapUseCases {
    private let tierMapRepository: TierMapRepository

    init(tierMapRepository: TierMapRepository) {
        self.tierMapRepository = tierMapRepository
    }
}

extension DefaultTierMapUseCases: TierMapUseCases {

}

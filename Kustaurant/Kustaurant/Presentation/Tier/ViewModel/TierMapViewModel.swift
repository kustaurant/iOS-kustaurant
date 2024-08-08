//
//  TierMapViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Foundation

protocol TierMapViewModelInput {}

protocol TierMapViewModelOutput {}

typealias TierMapViewModel = TierMapViewModelInput & TierMapViewModelOutput

final class DefaultTierMapViewModel: TierMapViewModel {
    private let tierUseCase: TierUseCases
    private let tierMapUseCase: TierMapUseCases
    
    // MARK: - Initialization
    init(
        tierUseCase: TierUseCases,
        tierMapUseCase: TierMapUseCases
    ) {
        self.tierUseCase = tierUseCase
        self.tierMapUseCase = tierMapUseCase
    }
}

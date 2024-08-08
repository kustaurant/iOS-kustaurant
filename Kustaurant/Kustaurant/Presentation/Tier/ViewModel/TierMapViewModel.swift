//
//  TierMapViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Foundation

protocol TierMapViewModelInput {
    func fetchTierMap()
}

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

// MARK: - Input
extension DefaultTierMapViewModel {
    func fetchTierMap() {
        Task {
            let result = await tierUseCase.fetchTierMap(cuisines: [.all], situations: [.all], locations: [.all])
            switch result {
            case .success(let data):
                print(data)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

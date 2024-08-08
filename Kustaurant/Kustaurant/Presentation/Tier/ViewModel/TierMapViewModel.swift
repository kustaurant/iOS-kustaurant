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

protocol TierMapViewModelOutput {
    var mapRestaurants: TierMapRestaurants? { get }
}

typealias TierMapViewModel = TierMapViewModelInput & TierMapViewModelOutput

final class DefaultTierMapViewModel: TierMapViewModel {
    private let tierUseCase: TierUseCases
    private let tierMapUseCase: TierMapUseCases
    
    var categories: [Category] = [Cuisine.all.category, Situation.all.category, Location.all.category]
    
    // MARK: Output
    var mapRestaurants: TierMapRestaurants?
    
    
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
            let result = await tierUseCase.fetchTierMap(
                cuisines: Category.extractCuisines(from: categories),
                situations: Category.extractSituations(from: categories),
                locations: Category.extractLocations(from: categories)
            )
            switch result {
            case .success(let data):
                mapRestaurants = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

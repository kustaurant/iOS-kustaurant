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
    var mapRestaurantsPublisher: Published<TierMapRestaurants?>.Publisher { get }
}

typealias TierMapViewModel = TierMapViewModelInput & TierMapViewModelOutput & TierBaseViewModel

final class DefaultTierMapViewModel: TierMapViewModel {
    private let tierUseCase: TierUseCases
    private let tierMapUseCase: TierMapUseCases
    
    
    @Published var categories: [Category]
    @Published var mapRestaurants: TierMapRestaurants?
    
    // MARK: Output
    var mapRestaurantsPublisher: Published<TierMapRestaurants?>.Publisher { $mapRestaurants }
    
    // MARK: - Initialization
    init(
        tierUseCase: TierUseCases,
        tierMapUseCase: TierMapUseCases,
        initialCategories: [Category]
    ) {
        self.tierUseCase = tierUseCase
        self.tierMapUseCase = tierMapUseCase
        self.categories = initialCategories
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

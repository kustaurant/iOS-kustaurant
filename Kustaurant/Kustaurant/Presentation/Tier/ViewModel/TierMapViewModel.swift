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
    var filteredCategories: [Category] { get }
    var mapRestaurantsPublisher: Published<TierMapRestaurants?>.Publisher { get }
}

typealias TierMapViewModel = TierMapViewModelInput & TierMapViewModelOutput

final class DefaultTierMapViewModel: TierMapViewModel {
    private let tierUseCase: TierUseCases
    private let tierMapUseCase: TierMapUseCases
    
    @Published private var categories: [Category]
    @Published var mapRestaurants: TierMapRestaurants?
    
    // MARK: Output
    var filteredCategories: [Category] {
        // 모든 카테고리가 "전체"인 경우, "전체"만 반환
        if categories.allSatisfy({ $0.displayName == "전체" }) && !categories.isEmpty {
            return [categories.first!]
        }
        // 그 외의 경우, "전체"가 아닌 카테고리만 반환
        return categories.filter { $0.displayName != "전체" }
    }
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

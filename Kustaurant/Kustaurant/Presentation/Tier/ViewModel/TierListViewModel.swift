//
//  TierListViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Combine

struct TierListViewModelActions {
    let showTierCategory: ([Category]) -> Void
}

protocol TierListViewModelInput {
    func fetchTierLists()
    func categoryButtonTapped()
    func updateCategories(categories: [Category])
}

protocol TierListViewModelOutput {
    var categories: [Category] { get set }
    var tierRestaurants: [Restaurant] { get }
    var tierRestaurantsPublisher: Published<[Restaurant]>.Publisher { get }
}

typealias TierListViewModel = TierListViewModelInput & TierListViewModelOutput

final class DefaultTierListViewModel: TierListViewModel {
    private let tierUseCase: TierUseCases
    private let actions: TierListViewModelActions
    
    private var listPage = 1
    private var hasMoreData = true
    
    // MARK: - Output
    var categories: [Category]
    @Published private(set) var tierRestaurants: [Restaurant] = []
    var tierRestaurantsPublisher: Published<[Restaurant]>.Publisher { $tierRestaurants }
    
    // MARK: - Initialization
    init(
        tierUseCase: TierUseCases,
        actions: TierListViewModelActions,
        initialCategories: [Category]
    ) {
        self.tierUseCase = tierUseCase
        self.actions = actions
        self.categories = initialCategories
    }
}

// MARK: - Input
extension DefaultTierListViewModel {
    func fetchTierLists() {
        guard hasMoreData else { return }
        
        Task {
            let cuisines = extractCuisines(from: categories)
            let situations = extractSituations(from: categories)
            let locations = extractLocations(from: categories)
            
            let result = await tierUseCase.fetchTierLists(
                cuisines: cuisines,
                situations: situations,
                locations: locations,
                page: listPage
            )
            
            switch result {
            case .success(let data):
                if data.isEmpty {
                    hasMoreData = false
                    return
                }
                tierRestaurants += data
                listPage += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func categoryButtonTapped() {
        actions.showTierCategory(categories)
    }
    
    func updateCategories(categories: [Category]) {
        self.categories = categories
    }
}

extension DefaultTierListViewModel {
    private func extractCuisines(from categories: [Category]) -> [Cuisine] {
        categories.compactMap {
            if case let .cuisine(cuisine) = $0.origin {
                return cuisine
            }
            return nil
        }
    }
    
    private func extractSituations(from categories: [Category]) -> [Situation] {
        categories.compactMap {
            if case let .situation(situation) = $0.origin {
                return situation
            }
            return nil
        }
    }
    
    private func extractLocations(from categories: [Category]) -> [Location] {
        categories.compactMap {
            if case let .location(location) = $0.origin {
                return location
            }
            return nil
        }
    }
}

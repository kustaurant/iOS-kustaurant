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
    
    // MARK: - Output
    var categories: [Category] = [Cuisine.all.category, Situation.all.category, Location.all.category]
    @Published private(set) var tierRestaurants: [Restaurant] = []
    var tierRestaurantsPublisher: Published<[Restaurant]>.Publisher { $tierRestaurants }
    
    // MARK: - Initialization
    init(
        tierUseCase: TierUseCases,
        actions: TierListViewModelActions
    ) {
        self.tierUseCase = tierUseCase
        self.actions = actions
    }
}

// MARK: - Input
extension DefaultTierListViewModel {
    func fetchTierLists() {
        Task {
            let result = await tierUseCase.fetchTierLists(cuisines: [.as], situations: [.all], locations: [.l1])
            switch result {
            case .success(let data):
                tierRestaurants += data
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

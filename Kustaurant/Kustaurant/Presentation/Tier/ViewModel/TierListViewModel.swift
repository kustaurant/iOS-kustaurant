//
//  TierListViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Combine

struct TierListViewModelActions {
    let showTierCategory: ([Category]) -> Void
    let showRestaurantDetail: (Int) -> Void
}

protocol TierListViewModelInput {
    func fetchTierLists()
    func categoryButtonTapped()
    func updateCategories(categories: [Category])
    func didTapRestaurant(restaurantId: Int)
    var actionPublisher: AnyPublisher<DefaultTierListViewModel.Action, Never> { get }
}

protocol TierListViewModelOutput {
    var categoriesPublisher: Published<[Category]>.Publisher { get }
    var tierRestaurants: [Restaurant] { get }
    var tierRestaurantsPublisher: Published<[Restaurant]>.Publisher { get }
}

typealias TierListViewModel = TierListViewModelInput & TierListViewModelOutput & TierBaseViewModel

extension DefaultTierListViewModel {
    enum Action {
        case showLoading(Bool)
    }
}

final class DefaultTierListViewModel: TierListViewModel {
    private let tierUseCase: TierUseCases
    private let actions: TierListViewModelActions
    
    @Published var categories: [Category]
    private var listPage = 1
    private var hasMoreData = true
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Output
    var categoriesPublisher: Published<[Category]>.Publisher { $categories }
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
            await MainActor.run {
                actionSubject.send(.showLoading(true))
            }
            
            defer {
                actionSubject.send(.showLoading(false))
            }
            
            let cuisines = Category.extractCuisines(from: categories)
            let situations = Category.extractSituations(from: categories)
            let locations = Category.extractLocations(from: categories)
            
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
        hasMoreData = true
        listPage = 1
        tierRestaurants.removeAll()
    }
    
    func didTapRestaurant(restaurantId: Int) {
        actions.showRestaurantDetail(restaurantId)
    }
}

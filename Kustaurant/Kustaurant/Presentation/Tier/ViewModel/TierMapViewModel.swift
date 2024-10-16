//
//  TierMapViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 8/8/24.
//

import Combine

struct TierMapViewModelActions {
    let showTierCategory: ([Category]) -> Void
    let showMapBottomSheet: (Restaurant) -> Void
    let hideMapBottomSheet: () -> Void
    let showRestaurantDetail: (Int) -> Void
}

protocol TierMapViewModelInput {
    func fetchTierMap()
    func categoryButtonTapped()
    func updateCategories(categories: [Category])
    func didTapMarker(restaurant: Restaurant)
    func didTapMap()
    func hideBottomSheet()
    func didTapRestaurant()
}

protocol TierMapViewModelOutput {
    var categoriesPublisher: Published<[Category]>.Publisher { get }
    var mapRestaurantsPublisher: Published<TierMapRestaurants?>.Publisher { get }
    var selectedRestaurant: Restaurant? { get }
    var actionPublisher: AnyPublisher<DefaultTierMapViewModel.Action, Never> { get }
}

typealias TierMapViewModel = TierMapViewModelInput & TierMapViewModelOutput & TierBaseViewModel

extension DefaultTierMapViewModel {
    enum Action {
        case showLoading(Bool)
    }
}


final class DefaultTierMapViewModel: TierMapViewModel {
    
    private let tierUseCase: TierUseCases
    private let tierMapUseCase: TierMapUseCases
    private let actions: TierMapViewModelActions
    
    @Published var categories: [Category]
    @Published var mapRestaurants: TierMapRestaurants?
    @Published var selectedRestaurant: Restaurant?
    
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    
    // MARK: Output
    var categoriesPublisher: Published<[Category]>.Publisher { $categories }
    var mapRestaurantsPublisher: Published<TierMapRestaurants?>.Publisher { $mapRestaurants }
    var actionPublisher: AnyPublisher<Action, Never> { actionSubject.eraseToAnyPublisher() }
    
    // MARK: - Initialization
    init(
        tierUseCase: TierUseCases,
        tierMapUseCase: TierMapUseCases,
        actions: TierMapViewModelActions,
        initialCategories: [Category]
    ) {
        self.tierUseCase = tierUseCase
        self.tierMapUseCase = tierMapUseCase
        self.actions = actions
        self.categories = initialCategories
    }
}

// MARK: - Input
extension DefaultTierMapViewModel {
    func fetchTierMap() {
        Task {
            await MainActor.run {
                actionSubject.send(.showLoading(true))
            }
            
            defer {
                actionSubject.send(.showLoading(false))
            }
            
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
    
    func categoryButtonTapped() {
        actions.showTierCategory(categories)
    }
    
    func updateCategories(categories: [Category]) {
        self.categories = categories
    }
    
    func didTapMarker(restaurant: Restaurant) {
        selectedRestaurant = restaurant
        Task {
            await MainActor.run {
                self.actions.showMapBottomSheet(restaurant)
            }
        }
    }
    
    func didTapMap() {
        hideBottomSheet()
    }
    
    func hideBottomSheet() {
        selectedRestaurant = nil
        Task {
            await MainActor.run {
                self.actions.hideMapBottomSheet()
            }
        }
    }
    
    func didTapRestaurant() {
        if let restaurant = selectedRestaurant {
            let restaurantId = restaurant.restaurantId ?? 0
            hideBottomSheet()
            actions.showRestaurantDetail(restaurantId)
        }
    }
}

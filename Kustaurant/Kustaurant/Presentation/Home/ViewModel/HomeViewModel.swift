//
//  HomeViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Combine

struct HomeViewModelActions {
    let showRestaurantDetail: (Restaurant) -> Void
    let showTierScene: (Cuisine) -> Void
}

protocol HomeViewModelInput {
    func fetchRestaurantLists()
    func restaurantListsDidSelect(restaurant: Restaurant)
    func categoryCellDidSelect(_ cuisineCategory: Cuisine)
}

protocol HomeViewModelOutput {
    var banners: [String] { get }
    var bannersPublisher: Published<[String]>.Publisher { get }
    var topRestaurants: [Restaurant] { get }
    var forMeRestaurants: [Restaurant] { get }
    var topRestaurantsPublisher: Published<[Restaurant]>.Publisher { get }
    var forMeRestaurantsPublisher: Published<[Restaurant]>.Publisher { get }
    var mainSections: [HomeSection] { get set }
    var mainSectionPublisher: Published<[HomeSection]>.Publisher { get }
    var cuisines: [Cuisine] { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

final class DefaultHomeViewModel: HomeViewModel {
    private let homeUseCase: HomeUseCases
    private let actions: HomeViewModelActions
    
    // MARK: - Output
    @Published var mainSections: [HomeSection] = [.categories]
    @Published private(set) var banners: [String] = []
    @Published private(set) var topRestaurants: [Restaurant] = []
    @Published private(set) var forMeRestaurants: [Restaurant] = []
    var bannersPublisher: Published<[String]>.Publisher { $banners }
    var topRestaurantsPublisher: Published<[Restaurant]>.Publisher { $topRestaurants }
    var forMeRestaurantsPublisher: Published<[Restaurant]>.Publisher { $forMeRestaurants }
    var mainSectionPublisher: Published<[HomeSection]>.Publisher { $mainSections }
    var cuisines: [Cuisine] = Cuisine.allCases
    
    // MARK: - Initialization
    init(
        homeUseCase: HomeUseCases,
        actions: HomeViewModelActions
    ) {
        self.homeUseCase = homeUseCase
        self.actions = actions
    }
}

// MARK: - Input
extension DefaultHomeViewModel {
    func categoryCellDidSelect(_ cuisineCategory: Cuisine) {
        actions.showTierScene(cuisineCategory)
    }
    
    func fetchRestaurantLists() {
        Task {
            let result = await homeUseCase.fetchRestaurantLists()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                topRestaurants = data.topRestaurantsByRating?.compactMap({$0}) ?? []
                forMeRestaurants = data.restaurantsForMe?.compactMap({$0}) ?? []
                banners = data.photoUrls?.compactMap({$0}) ?? []
            }
        }
    }
    
    func restaurantListsDidSelect(restaurant: Restaurant) {
//        actions.showRestaurantDetail(restaurant)
    }
}

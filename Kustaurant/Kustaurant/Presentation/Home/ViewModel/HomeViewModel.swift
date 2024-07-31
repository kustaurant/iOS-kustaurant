//
//  HomeViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Combine

struct HomeViewModelActions {
    let showRestaurantDetail: (Restaurant) -> Void
}

protocol HomeViewModelInput {
    var topRestaurants: [Restaurant] { get set }
    var forMeRestaurants: [Restaurant] { get set }
    func fetchRestaurantLists()
    func restaurantlistsDidSelect(restaurant: Restaurant)
}

protocol HomeViewModelOutput {
    var mainSections: [HomeSection] { get }
    var restaurantLists: PassthroughSubject<HomeRestaurantLists, Never> { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

final class DefaultHomeViewModel: HomeViewModel {
    private let homeUseCase: HomeUseCases
    private let actions: HomeViewModelActions
    
    // MARK: - Input
    var topRestaurants: [Restaurant] = []
    var forMeRestaurants: [Restaurant] = []
    
    // MARK: - Output
    var restaurantLists = PassthroughSubject<HomeRestaurantLists, Never>()
    var mainSections: [HomeSection] = [.banner, .categories, .topRestaurants, .forMeRestaurants]
    
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
    func fetchRestaurantLists() {
        Task {
            let result = await homeUseCase.fetchRestaurantLists()
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                restaurantLists.send(data)
            }
        }
    }
    
    func restaurantlistsDidSelect(restaurant: Restaurant) {
        actions.showRestaurantDetail(restaurant)
    }
}

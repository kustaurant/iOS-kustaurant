//
//  HomeViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/17/24.
//

import Combine

protocol HomeViewModelInput {
    var topRestaurants: [Restaurant] { get set }
    var forMeRestaurants: [Restaurant] { get set }
    func fetchRestaurantLists()
}

protocol HomeViewModelOutput {
    var mainSections: [HomeSection] { get set }
    var restaurantLists: PassthroughSubject<HomeRestaurantLists, Never> { get }
}

typealias HomeViewModel = HomeViewModelInput & HomeViewModelOutput

final class DefaultHomeViewModel: HomeViewModel {
    private let homeUseCase: HomeUseCases
    
    // MARK: - Input
    var topRestaurants: [Restaurant] = []
    var forMeRestaurants: [Restaurant] = []
    
    // MARK: - Output
    var restaurantLists = PassthroughSubject<HomeRestaurantLists, Never>()
    var mainSections: [HomeSection] = [.banner, .categories, .topRestaurants, .forMeRestaurants]
    
    // MARK: - Initialization
    init(homeUseCase: HomeUseCases) {
        self.homeUseCase = homeUseCase
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
}

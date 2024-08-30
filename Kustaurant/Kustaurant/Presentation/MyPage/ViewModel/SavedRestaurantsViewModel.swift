//
//  SavedRestaurantsViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import Foundation
import Combine

struct SavedRestaurantsViewModelActions {
    let pop: () -> Void
}

protocol SavedRestaurantsViewModelInput {
    func getFavoriteRestaurants()
    func didTapBackButton()
}
protocol SavedRestaurantsViewModelOutput {
    var favoriteRestaurants: [FavoriteRestaurant] { get }
    var favoriteRestaurantsPublisher: Published<[FavoriteRestaurant]>.Publisher { get }
}

typealias SavedRestaurantsViewModel = SavedRestaurantsViewModelInput & SavedRestaurantsViewModelOutput

final class DefaultSavedRetaurantsViewModel: SavedRestaurantsViewModel {
    
    private let actions: SavedRestaurantsViewModelActions
    private let myPageUseCases: MyPageUseCases
    @Published var favoriteRestaurants: [FavoriteRestaurant] = []
    var favoriteRestaurantsPublisher: Published<[FavoriteRestaurant]>.Publisher { $favoriteRestaurants }
    
    init(actions: SavedRestaurantsViewModelActions, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultSavedRetaurantsViewModel {
    
    func getFavoriteRestaurants() {
        Task {
            let result = await myPageUseCases.getFavoriteRestaurants()
            switch result {
            case .success(let restaurants):
                favoriteRestaurants = restaurants
            case .failure:
                return
            }
        }
    }
    
    func didTapBackButton() {
        actions.pop()
    }
}

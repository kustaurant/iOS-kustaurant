//
//  DrawResultViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import Foundation
import Combine
import UIKit

struct DrawResultViewModelActions {
    let didTapBackButton: () -> Void
}

protocol DrawResultViewModelInput {
    func didTapBackButton() -> Void
    func shuffleRestaurants() -> Void
}

protocol DrawResultViewModelOutput {
    var restaurants: [Restaurant] { get }
    var restaurantsPublisher: Published<[Restaurant]>.Publisher { get }
}

typealias DrawResultViewModel = DrawResultViewModelInput & DrawResultViewModelOutput

final class DefaultDrawResultViewModel: DrawResultViewModel {
    private let actions: DrawResultViewModelActions
    @Published var restaurants: [Restaurant] = []
    var restaurantsPublisher: Published<[Restaurant]>.Publisher { $restaurants }
    
    init(
        actions: DrawResultViewModelActions,
        restaurants: [Restaurant]
    ) {
        self.actions = actions
        self.restaurants = restaurants
    }
}

extension DefaultDrawResultViewModel {
    
    func didTapBackButton() {
        actions.didTapBackButton()
    }
    
    func shuffleRestaurants() {
        var currentRestaurants = restaurants.shuffled()
        
        while currentRestaurants.count < 30 {
            currentRestaurants.append(contentsOf: restaurants)
        }
        
        restaurants = Array(currentRestaurants.prefix(30))
    }
}

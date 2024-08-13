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
    func fetchDrawedRestaurants()
    func didTapReDrawButton() -> Void
}

protocol DrawResultViewModelOutput {
    var restaurants: [UIColor] { get }
    var restaurantsPublisher: Published<[UIColor]>.Publisher { get }
}

typealias DrawResultViewModel = DrawResultViewModelInput & DrawResultViewModelOutput

final class DefaultDrawResultViewModel: DrawResultViewModel {
    
    private let actions: DrawResultViewModelActions
    @Published var restaurants: [UIColor] = []
    var restaurantsPublisher: Published<[UIColor]>.Publisher { $restaurants }
    
    init(actions: DrawResultViewModelActions) {
        self.actions = actions
    }
}

extension DefaultDrawResultViewModel {
    
    func didTapBackButton() {
        actions.didTapBackButton()
    }
    
    func fetchDrawedRestaurants() {
        let fetchedResaturants: [UIColor] = [.red, .blue, .yellow, .brown, .cyan, .purple, .lightGray]
        restaurants = makeRepeatingRestaurantsUpto30(restaurants: fetchedResaturants)
    }
    
    func makeRepeatingRestaurantsUpto30(restaurants: [UIColor]) -> [UIColor] {
        var currentRestaurants = restaurants.shuffled()
        
        while currentRestaurants.count < 30 {
            currentRestaurants.append(contentsOf: restaurants)
        }
        
        return Array(currentRestaurants.prefix(30))
    }
    
    func didTapReDrawButton() {
        restaurants = makeRepeatingRestaurantsUpto30(restaurants: restaurants)
    }
}

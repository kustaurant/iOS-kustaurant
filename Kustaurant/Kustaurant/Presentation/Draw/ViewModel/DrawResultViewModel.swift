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
    func didTapReDrawButton() -> Void
}

protocol DrawResultViewModelOutput {
    var isDrawing: Bool { get }
    var isDrawingPublisher: Published<Bool>.Publisher { get }
    var restaurants: [Restaurant] { get }
    var restaurantsPublisher: Published<[Restaurant]>.Publisher { get }
}

typealias DrawResultViewModel = DrawResultViewModelInput & DrawResultViewModelOutput

final class DefaultDrawResultViewModel: DrawResultViewModel {
    private let actions: DrawResultViewModelActions
    @Published var restaurants: [Restaurant] = []
    var restaurantsPublisher: Published<[Restaurant]>.Publisher { $restaurants }
    @Published var isDrawing: Bool = false
    var isDrawingPublisher: Published<Bool>.Publisher { $isDrawing }
    
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
    
    func makeRepeatingRestaurantsUpto30(restaurants: [Restaurant]) -> [Restaurant] {
        var currentRestaurants = restaurants.shuffled()
        
        while currentRestaurants.count < 30 {
            currentRestaurants.append(contentsOf: restaurants)
        }
        
        return Array(currentRestaurants.prefix(30))
    }
    
    func didTapReDrawButton() {
        isDrawing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + DrawResultViewHandler.rouletteAnimationDurationSeconds) { [weak self] in
            self?.isDrawing = false
        }
        restaurants = makeRepeatingRestaurantsUpto30(restaurants: restaurants)
    }
}

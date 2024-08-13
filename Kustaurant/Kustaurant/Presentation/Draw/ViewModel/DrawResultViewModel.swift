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
    var locations: [Location] { get }
    var cuisines: [Cuisine] { get }
}

protocol DrawResultViewModelOutput {
    var isDrawing: Bool { get }
    var isDrawingPublisher: Published<Bool>.Publisher { get }
    var restaurants: [Restaurant] { get }
    var restaurantsPublisher: Published<[Restaurant]>.Publisher { get }
}

typealias DrawResultViewModel = DrawResultViewModelInput & DrawResultViewModelOutput

final class DefaultDrawResultViewModel: DrawResultViewModel {
    var locations: [Location]
    var cuisines: [Cuisine]
    
    private let drawUseCases: DrawUseCases
    private let actions: DrawResultViewModelActions
    @Published var restaurants: [Restaurant] = []
    var restaurantsPublisher: Published<[Restaurant]>.Publisher { $restaurants }
    @Published var isDrawing: Bool = false
    var isDrawingPublisher: Published<Bool>.Publisher { $isDrawing }
    
    init(
        drawUseCases: DrawUseCases,
        actions: DrawResultViewModelActions,
        locations: [Location],
        cuisines: [Cuisine]
    ) {
        self.drawUseCases = drawUseCases
        self.actions = actions
        self.locations = locations
        self.cuisines = cuisines
    }
}

extension DefaultDrawResultViewModel {
    
    func didTapBackButton() {
        actions.didTapBackButton()
    }
    
    func fetchDrawedRestaurants() {
        isDrawing = true
        Task {
            let result = await drawUseCases.getRestaurantsBy(locations: locations, cuisines: cuisines)
            switch result {
            case .failure(let error):
                print(#file, #function, error.localizedDescription)
            case .success(let data):
                restaurants = makeRepeatingRestaurantsUpto30(restaurants: data)
                try? await Task.sleep(nanoseconds: UInt64((DrawResultViewHandler.rouletteAnimationDurationSeconds) * 1_000_000_000))
                isDrawing = false
            }
        }
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

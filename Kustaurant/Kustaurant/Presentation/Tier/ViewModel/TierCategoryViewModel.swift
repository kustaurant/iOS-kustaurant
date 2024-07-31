//
//  TierCategoryViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import Foundation

protocol TierCategoryViewModelInput {
    func selectCategories(categories: [Category])
}

protocol TierCategoryViewModelOutput {
    var cuisines: [Category] { get }
    var situations: [Category] { get }
    var locations: [Category] { get }
}

typealias TierCategoryViewModel = TierCategoryViewModelInput & TierCategoryViewModelOutput

final class DefaultTierCategoryViewModel: TierCategoryViewModel {
    @Published var cuisines: [Category] = Cuisine.allCases.map({ $0.category })
    @Published var situations: [Category] = Situation.allCases.map({ $0.category})
    @Published var locations: [Category] = Location.allCases.map({ $0.category })
    
extension DefaultTierCategoryViewModel {
    func selectCategories(categories: [Category]) {
        for category in categories {
            switch category.origin {
            case .cuisine(let cuisine):
                if let index = cuisines.firstIndex(where: { $0.origin == .cuisine(cuisine) }) {
                    cuisines[index].isSelect = true
                }
            case .situation(let situation):
                if let index = situations.firstIndex(where: { $0.origin == .situation(situation) }) {
                    situations[index].isSelect = true
                }
            case .location(let location):
                if let index = locations.firstIndex(where: { $0.origin == .location(location) }) {
                    locations[index].isSelect = true
                }
            }
        }
    }
}

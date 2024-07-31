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
    var cuisinesPublisher: Published<[Category]>.Publisher { get }
    var situationsPublisher: Published<[Category]>.Publisher { get }
    var locationsPublisher: Published<[Category]>.Publisher { get }
}

typealias TierCategoryViewModel = TierCategoryViewModelInput & TierCategoryViewModelOutput

final class DefaultTierCategoryViewModel: TierCategoryViewModel {
    @Published var cuisines: [Category] = Cuisine.allCases.map({ $0.category })
    @Published var situations: [Category] = Situation.allCases.map({ $0.category})
    @Published var locations: [Category] = Location.allCases.map({ $0.category })
    
    var cuisinesPublisher: Published<[Category]>.Publisher { $cuisines }
    var situationsPublisher: Published<[Category]>.Publisher { $situations }
    var locationsPublisher: Published<[Category]>.Publisher { $locations }
    
    init(categories: [Category]) {
        selectCategories(categories: categories)
    }
}

extension DefaultTierCategoryViewModel {
    func selectCategories(categories: [Category]) {
        for category in categories {
            switch category.origin {
            case .cuisine(let cuisine):
                updateCategorySelection(for: &cuisines, selected: cuisine, allCase: .all)
            case .situation(let situation):
                updateCategorySelection(for: &situations, selected: situation, allCase: .all)
            case .location(let location):
                updateCategorySelection(for: &locations, selected: location, allCase: .all)
            }
        }
    }
    
    private func updateCategorySelection<T: Equatable>(for categories: inout [Category], selected: T, allCase: T) {
        if selected == allCase {
            // "all" 버튼을 클릭한 경우
            for i in 0..<categories.count {
                categories[i].isSelect = (categories[i].origin.value() as? T == allCase)
            }
        } else {
            // "all"이 아닌 버튼을 클릭한 경우
            if let allIndex = categories.firstIndex(where: { ($0.origin.value() as? T) == allCase }) {
                categories[allIndex].isSelect = false
            }
            if let index = categories.firstIndex(where: { ($0.origin.value() as? T) == selected }) {
                categories[index].isSelect.toggle()
            }
        }
    }
}

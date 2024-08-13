//
//  TierCategoryViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import Foundation

struct TierCategoryViewModelActions {
    let receiveTierCategories: (_ categories: [Category]) -> Void
}

protocol TierCategoryViewModelInput {
    func selectCategories(categories: [Category])
    func updateTierCategories()
}

protocol TierCategoryViewModelOutput {
    var initialCategories: [Category] { get }
    var cuisines: [Category] { get }
    var situations: [Category] { get }
    var locations: [Category] { get }
    var cuisinesPublisher: Published<[Category]>.Publisher { get }
    var situationsPublisher: Published<[Category]>.Publisher { get }
    var locationsPublisher: Published<[Category]>.Publisher { get }
}

typealias TierCategoryViewModel = TierCategoryViewModelInput & TierCategoryViewModelOutput

final class DefaultTierCategoryViewModel: TierCategoryViewModel {
    private let actions: TierCategoryViewModelActions
    
    // MARK: Output
    var initialCategories: [Category] = []
    @Published var cuisines: [Category] = Cuisine.allCases.map({ $0.category })
    @Published var situations: [Category] = Situation.allCases.map({ $0.category})
    @Published var locations: [Category] = Location.allCases.map({ $0.category })
    var cuisinesPublisher: Published<[Category]>.Publisher { $cuisines }
    var situationsPublisher: Published<[Category]>.Publisher { $situations }
    var locationsPublisher: Published<[Category]>.Publisher { $locations }
    
    init(
        actions: TierCategoryViewModelActions,
        categories: [Category]
    ) {
        self.actions = actions
        selectCategories(categories: categories)
        initialCategories = cuisines + situations + locations
    }
}

// MARK: - Input
extension DefaultTierCategoryViewModel {
    func updateTierCategories() {
        let categories = (cuisines + situations + locations).filter({ $0.isSelect })
        actions.receiveTierCategories(categories)
    }
    
    func selectCategories(categories: [Category]) {
        for category in categories {
            switch category.origin {
            case .cuisine(let cuisine):
                updateCategorySelection(for: &cuisines, selected: cuisine, exclusiveCases: [.all, .jh])
            case .situation(let situation):
                updateCategorySelection(for: &situations, selected: situation, exclusiveCases: [.all])
            case .location(let location):
                updateCategorySelection(for: &locations, selected: location, exclusiveCases: [.all])
            }
        }
    }
    
    private func updateCategorySelection<T: Equatable>(
        for categories: inout [Category],
        selected: T,
        exclusiveCases: [T]
    ) {
        if exclusiveCases.contains(selected) {
            // "all" 또는 "jh" 버튼을 클릭한 경우: 다른 모든 선택 해제
            for i in 0..<categories.count {
                categories[i].isSelect = (categories[i].origin.value() as? T == selected)
            }
        } else {
            // "all"이나 "jh"가 아닌 버튼을 클릭한 경우
            if let index = categories.firstIndex(where: { ($0.origin.value() as? T) == selected }) {
                // 해당 카테고리가 이미 선택된 상태라면, 해제할 때 최소 하나의 선택이 남아있는지 확인
                if categories[index].isSelect {
                    let selectedCount = categories.filter { $0.isSelect }.count
                    if selectedCount > 1 {
                        // 현재 선택된 상태를 해제
                        categories[index].isSelect.toggle()
                    }
                } else {
                    // 선택되지 않은 상태라면 그냥 선택
                    categories[index].isSelect.toggle()
                    // "all"이나 "jh"가 선택된 상태에서 다른 항목이 선택되면 해제
                    for exclusiveCase in exclusiveCases {
                        if let exclusiveIndex = categories.firstIndex(where: { ($0.origin.value() as? T) == exclusiveCase }) {
                            categories[exclusiveIndex].isSelect = false
                        }
                    }
                }
            }
        }
    }
}

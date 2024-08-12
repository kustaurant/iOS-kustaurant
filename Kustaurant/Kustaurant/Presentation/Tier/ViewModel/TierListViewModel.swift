//
//  TierListViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import Combine

struct TierListViewModelActions {
    let showTierCategory: ([Category]) -> Void
}

protocol TierListViewModelInput {
    func fetchTierLists()
    func categoryButtonTapped()
    func updateCategories(categories: [Category])
}

protocol TierListViewModelOutput {
    var categories: [Category] { get set }
    var categoriesPublisher: Published<[Category]>.Publisher { get }
    var filteredCategories: [Category] { get }
    var tierRestaurants: [Restaurant] { get }
    var tierRestaurantsPublisher: Published<[Restaurant]>.Publisher { get }
}

typealias TierListViewModel = TierListViewModelInput & TierListViewModelOutput

final class DefaultTierListViewModel: TierListViewModel {
    private let tierUseCase: TierUseCases
    private let actions: TierListViewModelActions
    
    private var listPage = 1
    private var hasMoreData = true
    
    // MARK: - Output
    @Published var categories: [Category]
    var categoriesPublisher: Published<[Category]>.Publisher { $categories }
    var filteredCategories: [Category] {
        // 모든 카테고리가 "전체"인 경우, "전체"만 반환
        if categories.allSatisfy({ $0.displayName == "전체" }) && !categories.isEmpty {
            return [categories.first!]
        }
        // 그 외의 경우, "전체"가 아닌 카테고리만 반환
        return categories.filter { $0.displayName != "전체" }
    }
    @Published private(set) var tierRestaurants: [Restaurant] = []
    var tierRestaurantsPublisher: Published<[Restaurant]>.Publisher { $tierRestaurants }
    
    // MARK: - Initialization
    init(
        tierUseCase: TierUseCases,
        actions: TierListViewModelActions,
        initialCategories: [Category]
    ) {
        self.tierUseCase = tierUseCase
        self.actions = actions
        self.categories = initialCategories
    }
}

// MARK: - Input
extension DefaultTierListViewModel {
    func fetchTierLists() {
        guard hasMoreData else { return }
        
        Task {
            let cuisines = Category.extractCuisines(from: categories)
            let situations = Category.extractSituations(from: categories)
            let locations = Category.extractLocations(from: categories)
            
            let result = await tierUseCase.fetchTierLists(
                cuisines: cuisines,
                situations: situations,
                locations: locations,
                page: listPage
            )
            
            switch result {
            case .success(let data):
                if data.isEmpty {
                    hasMoreData = false
                    return
                }
                tierRestaurants += data
                listPage += 1
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func categoryButtonTapped() {
        actions.showTierCategory(categories)
    }
    
    func updateCategories(categories: [Category]) {
        self.categories = categories
        hasMoreData = true
        listPage = 1
        tierRestaurants.removeAll()
    }
}

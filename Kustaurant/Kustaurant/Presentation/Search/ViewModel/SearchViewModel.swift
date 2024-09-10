//
//  SearchViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation

struct SearchViewModelActions {
    let didTapBackButton: () -> Void
    let didTapRestaurant: (Int) -> Void
}

final class SearchViewModel: ObservableObject {
    
    private let actions: SearchViewModelActions
    private let searchUseCases: SearchUseCases
    @Published var isSearching = false
    @Published var searchText: String = ""
    @Published var restaurants: [Restaurant] = []

    init(actions: SearchViewModelActions, searchUseCases: SearchUseCases) {
        self.searchUseCases = searchUseCases
        self.actions = actions
    }
}

extension SearchViewModel {
    
    func searchRestaurants() {
        isSearching = true
        Task {
            if searchText != "" {
                let result = await searchUseCases.search(term: searchText)
                await MainActor.run {
                    switch result {
                    case .success(let restaurants):
                        self.restaurants = restaurants
                    case .failure(let error):
                        Logger.error("식당을 검색하는데 실패했습니다 \(error.localizedDescription)", category: .network)
                    }
                    isSearching = false
                }
            }
        }
    }
    
    func didTapBackButton() {
        actions.didTapBackButton()
    }
    
    func didTapRestaurant(restaurantId: Int) {
        actions.didTapRestaurant(restaurantId)
    }
}

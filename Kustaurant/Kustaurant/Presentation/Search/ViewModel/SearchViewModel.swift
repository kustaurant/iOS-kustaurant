//
//  SearchViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation

protocol SearchViewModelActions {
}

final class SearchViewModel: ObservableObject {
    
    private let searchUseCases: SearchUseCases

    init(searchUseCases: SearchUseCases) {
        self.searchUseCases = searchUseCases
    }
}

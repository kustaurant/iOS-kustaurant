//
//  SearchSceneDIContainer.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation
import SwiftUI

final class SearchSceneDIContainer: SearchFlowCoordinatorDependencies {
    
    private let dependencies: Dependencies
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeSearchView() -> SearchView {
        return SearchView(viewModel: makeSearchViewModel())
    }
    
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        SearchFlowCoordinator(dependencies: self, navigationController: navigationController)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel()
    }
}

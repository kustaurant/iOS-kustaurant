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
    
    func makeSearchView(actions: SearchViewModelActions) -> SearchView {
        return SearchView(viewModel: makeSearchViewModel(actions: actions))
    }
    
    func makeSearchFlowCoordinator(
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController,
        rootNavigationController: UINavigationController
    ) -> SearchFlowCoordinator {
        SearchFlowCoordinator(
            dependencies: self,
            appDIContainer: appDIContainer,
            navigationController: navigationController,
            rootNavigationController: rootNavigationController
        )
    }
    
    func makeSearchViewModel(actions: SearchViewModelActions) -> SearchViewModel {
        SearchViewModel(actions: actions, searchUseCases: makeSearchUseCases())
    }
    
    func makeSearchUseCases() -> SearchUseCases {
        DefaultSearchUseCases(searchRepository: makeSearchRepository())
    }
    
    func makeSearchRepository() -> SearchRepository {
        DefaultSearchRepository(networkService: dependencies.networkService)
    }
}

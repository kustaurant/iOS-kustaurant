//
//  SearchFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation
import SwiftUI


protocol SearchFlowCoordinatorDependencies {
    func makeSearchView(actions: SearchViewModelActions) -> SearchView
}

final class SearchFlowCoordinator: Coordinator {
    
    private let dependencies: SearchFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(dependencies: SearchFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension SearchFlowCoordinator {
    func start() {
        let actions = SearchViewModelActions(didTapBackButton: popAnimated)
        let searchView = dependencies.makeSearchView(actions: actions)
        let hostingController = UIHostingController(rootView: searchView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func popAnimated() {
        pop(animated: true)
    }
}

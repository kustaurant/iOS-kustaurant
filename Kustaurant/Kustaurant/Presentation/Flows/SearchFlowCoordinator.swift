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
    private var appDIContainer: AppDIContainer
    var navigationController: UINavigationController
    var rootNavigationController: UINavigationController
    
    init(
        dependencies: SearchFlowCoordinatorDependencies,
        appDIContainer: AppDIContainer,
        navigationController: UINavigationController,
        rootNavigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.appDIContainer = appDIContainer
        self.navigationController = navigationController
        self.rootNavigationController = rootNavigationController
    }
}

extension SearchFlowCoordinator {
    func start() {
        let actions = SearchViewModelActions(
            didTapBackButton: popAnimated,
            didTapRestaurant: showRestaurantDetail
        )
        let searchView = dependencies.makeSearchView(actions: actions)
        let hostingController = UIHostingController(rootView: searchView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func popAnimated() {
        pop(animated: true)
    }
    
    private func showRestaurantDetail(restaurantId: Int) {
        let restaurantDetailSceneDIContainer = appDIContainer.makeRestaurantDetailSceneDIContainer()
        let flow = restaurantDetailSceneDIContainer.makeRestaurantDetailFlowCoordinator(
            navigationController: rootNavigationController
        )
        flow.start(id: restaurantId)
    }
}

//
//  SearchFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/22/24.
//

import Foundation
import SwiftUI


protocol SearchFlowCoordinatorDependencies {
    func makeSearchView() -> SearchView
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
        let searchView = dependencies.makeSearchView()
        let hostingController = UIHostingController(rootView: searchView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

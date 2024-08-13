//
//  RecommendSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class DrawSceneDIContainer: DrawFlowCoordinatorDependencies {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeDrawFlowCoordinator(navigationController: UINavigationController) -> DrawFlowCoordinator {
        DrawFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeDrawViewController(actions: DrawViewModelActions) -> DrawViewController {
        DrawViewController(viewModel: makeDrawViewModel(actions: actions))
    }
    
    func makeDrawViewModel(actions: DrawViewModelActions) -> DrawViewModel {
        DefaultDrawViewModel(actions: actions)
    }
    
    func makeDrawResultViewController(actions: DrawResultViewModelActions, locations: [Location], cuisines: [Cuisine]) -> DrawResultViewController {
        DrawResultViewController(viewModel: makeDrawResultViewModel(actions: actions, locations: locations, cuisines: cuisines))
    }
    
    func makeDrawResultViewModel(actions: DrawResultViewModelActions, locations: [Location], cuisines: [Cuisine]) -> DrawResultViewModel {
        return DefaultDrawResultViewModel(
            drawUseCases: makeDrawUseCases(),
            actions: actions,
            locations: locations,
            cuisines: cuisines
        )
    }
    
    func makeDrawUseCases() -> DrawUseCases {
        DefaultDrawUseCases(drawRepository: makeDrawRepository())
    }
    
    func makeDrawRepository() -> DrawRepository {
        DefaultDrawRepository(networkService: dependencies.networkService)
    }
}

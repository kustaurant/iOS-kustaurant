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
    
    func makeDrawFlowCoordinator(appDIContainer: AppDIContainer, navigationController: UINavigationController) -> DrawFlowCoordinator {
        DrawFlowCoordinator(
            appDIContainer: appDIContainer,
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeDrawViewController(actions: DrawViewModelActions) -> DrawViewController {
        DrawViewController(viewModel: makeDrawViewModel(actions: actions))
    }
    
    func makeDrawViewModel(actions: DrawViewModelActions) -> DrawViewModel {
        DefaultDrawViewModel(actions: actions, drawUseCases: makeDrawUseCases())
    }
    
    func makeDrawResultViewController(actions: DrawResultViewModelActions, restaurants: [Restaurant]) -> DrawResultViewController {
        DrawResultViewController(viewModel: makeDrawResultViewModel(actions: actions, restaurants: restaurants))
    }
    
    func makeDrawResultViewModel(actions: DrawResultViewModelActions, restaurants: [Restaurant]) -> DrawResultViewModel {
        return DefaultDrawResultViewModel(
            actions: actions,
            restaurants: restaurants
        )
    }
    
    func makeDrawUseCases() -> DrawUseCases {
        DefaultDrawUseCases(drawRepository: makeDrawRepository())
    }
    
    func makeDrawRepository() -> DrawRepository {
        DefaultDrawRepository(networkService: dependencies.networkService)
    }
}

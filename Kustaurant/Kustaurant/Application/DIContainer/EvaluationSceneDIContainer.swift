//
//  EvaluationSceneDIContainer.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit

final class EvaluationSceneDIContainer: EvaluationFlowCoordinatorDependencies {
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: EvaluationSceneDIContainer.Dependencies
    
    init(dependencies: EvaluationSceneDIContainer.Dependencies) {
        self.dependencies = dependencies
    }
}

extension EvaluationSceneDIContainer {
    
    func makeEvaluationFlowCoordianator(navigationController: UINavigationController) -> EvaluationFlowCoordinator {
        EvaluationFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeEvaluationViewController(
        with id: Int,
        actions: EvaluationViewModelActions
    ) -> EvaluationViewController {
        EvaluationViewController(
            viewModel: makeEvaluationViewModel(
                id: id,
                actions: actions
            )
        )
    }
    
    func makeEvaluationViewModel(
        id: Int,
        actions: EvaluationViewModelActions
    ) -> EvaluationViewModel {
        DefaultEvaluationViewModel(
            actions: actions,
            repository: makeEvaluationRepository(id: id)
        )
    }
    
    func makeEvaluationRepository(id: Int) -> EvaluationRepository {
        DefaultEvaluationRepository(
            networkService: dependencies.networkService,
            restaurantID: id
        )
    }
}

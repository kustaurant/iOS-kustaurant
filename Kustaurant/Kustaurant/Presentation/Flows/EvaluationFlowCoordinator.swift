//
//  EvaluationFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit

protocol EvaluationFlowCoordinatorDependencies {
    func makeEvaluationViewController(actions: EvaluationViewModelActions) -> EvaluationViewController
}

final class EvaluationFlowCoordinator: Coordinator {
    
    private let dependencies: EvaluationFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(dependencies: EvaluationFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension EvaluationFlowCoordinator {
    func start() {
        let actions = EvaluationViewModelActions(
            pop: popAnimated
        )
        let viewController = dependencies.makeEvaluationViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popAnimated() {
        pop(animated: true)
    }
}

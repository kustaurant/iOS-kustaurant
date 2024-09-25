//
//  EvaluationFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit

protocol EvaluationFlowCoordinatorDependencies {
    func makeEvaluationViewController(with id: Int, actions: EvaluationViewModelActions, titleData: RestaurantDetailTitle) -> EvaluationViewController
}

final class EvaluationFlowCoordinator: Coordinator {
    
    private let dependencies: EvaluationFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(dependencies: EvaluationFlowCoordinatorDependencies, navigationController: UINavigationController) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
    
    func start() {}
}

extension EvaluationFlowCoordinator {
    func start(
        id: Int,
        titleData: RestaurantDetailTitle,
        parentVC: UIViewController?
    ) {
        let actions = EvaluationViewModelActions(
            pop: popAnimated
        )
        let viewController = dependencies.makeEvaluationViewController(with: id, actions: actions, titleData: titleData)
        viewController.delegate = parentVC as? any EvaluationViewControllerDelegate
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popAnimated() {
        pop(animated: true)
    }
}

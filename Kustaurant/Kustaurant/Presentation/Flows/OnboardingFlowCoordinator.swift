//
//  OnboardingFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

protocol OnboardingFlowCoordinatorDependencies {
    func makeOnboardingViewController() -> OnboardingViewController
    func makeLoginViewController() -> LoginViewController
}

final class OnboardingFlowCoordinator: Coordinator {
    
    private let dependencies: OnboardingFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: OnboardingFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension OnboardingFlowCoordinator {
    
    func start() {
        let viewController = dependencies.makeOnboardingViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showLogin() {
        let viewController = dependencies.makeLoginViewController()
        navigationController.pushViewController(viewController, animated: false)
    }
}

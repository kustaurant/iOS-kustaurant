//
//  OnboardingFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

protocol OnboardingSceneDelegate: AnyObject {
    func onLoginSuccess()
}

protocol OnboardingFlowCoordinatorDependencies {
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> OnboardingViewController
    func makeLoginViewController(actions: OnboardingViewModelActions) -> LoginViewController
}

final class OnboardingFlowCoordinator: Coordinator {
    
    private let dependencies: OnboardingFlowCoordinatorDependencies
    var navigationController: UINavigationController
    weak var delegate: OnboardingSceneDelegate?
    
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
        let actions = OnboardingViewModelActions(initiateTabs: delegate?.onLoginSuccess)
        let viewController = dependencies.makeOnboardingViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showLogin() {
        let actions = OnboardingViewModelActions(initiateTabs: delegate?.onLoginSuccess)
        let viewController = dependencies.makeLoginViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: false)
    }
}

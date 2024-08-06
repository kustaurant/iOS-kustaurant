//
//  OnboardingFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

protocol OnboardingFlowCoordinatorDependencies {
    func makeSplashViewController(actions: SplashViewModelActions) -> SplashViewController
}

final class OnboardingFlowCoordinator: Coordinator {
    
    weak var delegate: AppFlowCoordinatorDelegate?
    
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
        let viewController = dependencies.makeSplashViewController(
            actions: SplashViewModelActions(showLoginPage: showLoginPage, showTabs: showTabs)
        )
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showLoginPage() {
    }
    
    func showTabs() {
        navigationController.popToRootViewController(animated: false)
        delegate?.showTab()
    }
}

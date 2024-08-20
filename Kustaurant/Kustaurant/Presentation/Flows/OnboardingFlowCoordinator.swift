//
//  OnboardingFlowCoordinator.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

protocol OnboardingFlowCoordinatorDependencies {
    func makeOnboardingViewController(actions: OnboardingViewModelActions) -> OnboardingViewController
    func makeLoginViewController(actions: OnboardingViewModelActions) -> LoginViewController
}

final class OnboardingFlowCoordinator: Coordinator {
    
    private let dependencies: OnboardingFlowCoordinatorDependencies
    var navigationController: UINavigationController
    weak var appFlowNavigating: AppFlowCoordinatorNavigating?
    
    init(
        dependencies: OnboardingFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension OnboardingFlowCoordinator {
    
    /// 앱 최초 실행시 보여지는 OnBoardingView
    func start() {
        let actions = OnboardingViewModelActions(initiateTabs: appFlowNavigating?.showTab)
        let viewController = dependencies.makeOnboardingViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    /// 앱을 실행한 적이 있으면 보여지는 LoginView
    func showLogin() {
        let actions = OnboardingViewModelActions(initiateTabs: appFlowNavigating?.showTab)
        let viewController = dependencies.makeLoginViewController(actions: actions)
        navigationController.pushViewController(viewController, animated: false)
    }
}

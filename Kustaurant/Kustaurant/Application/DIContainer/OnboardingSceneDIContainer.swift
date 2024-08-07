//
//  OnboardingSceneDIContainer.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

final class OnboardingSceneDIContainer: OnboardingFlowCoordinatorDependencies {
    
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeOnboardingFlowCoordinator(navigationController: UINavigationController) -> OnboardingFlowCoordinator {
        OnboardingFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
    
    func makeOnboardingViewController() -> OnboardingViewController {
        OnboardingViewController(viewModel: makeOnboardingViewModel())
    }
    
    func makeOnboardingViewModel() -> OnboardingViewModel {
        DefaultOnboardingViewModel()
    }
}

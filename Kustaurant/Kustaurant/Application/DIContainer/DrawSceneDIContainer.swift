//
//  RecommendSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class DrawSceneDIContainer: DrawFlowCoordinatorDependencies {
    
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
    
    func makeDrawResultViewController() -> DrawResultViewController {
        DrawResultViewController(viewModel: makeDrawResultViewModel())
    }
    
    func makeDrawResultViewModel() -> DrawResultViewModel {
        return DefaultDrawResultViewModel()
    }
}

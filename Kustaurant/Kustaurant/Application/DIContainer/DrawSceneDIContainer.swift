//
//  RecommendSceneDIContainer.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class DrawSceneDIContainer: DrawFlowCoordinatorDependencies {
    func makeDrawViewController() -> DrawViewController {
        DrawViewController(viewModel: makeDrawViewModel())
    }
    
    func makeDrawViewModel() -> DrawViewModel {
        DefaultDrawViewModel()
    }
    
    func makeDrawFlowCoordinator(navigationController: UINavigationController) -> DrawFlowCoordinator {
        DrawFlowCoordinator(
            dependencies: self,
            navigationController: navigationController
        )
    }
}

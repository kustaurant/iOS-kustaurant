//
//  CommunityFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol CommunityFlowCoordinatorDependencies {
    func makeCommunityViewController(actions: CommunityViewModelActions) -> CommunityViewController
    func makeCommunityPostDetailViewController() -> CommunityPostDetailViewController
}

final class CommunityFlowCoordinator: Coordinator {
    private let dependencies: CommunityFlowCoordinatorDependencies
    var navigationController: UINavigationController
    
    init(
        dependencies: CommunityFlowCoordinatorDependencies,
        navigationController: UINavigationController
    ) {
        self.dependencies = dependencies
        self.navigationController = navigationController
    }
}

extension CommunityFlowCoordinator {
    func start() {
        let actions = CommunityViewModelActions(showPostDetail: showPostDetail)
        let viewController = dependencies.makeCommunityViewController(actions: actions)
        let image = UIImage(named: TabBarPage.community.pageImageName() + "_off")?.withRenderingMode(.alwaysOriginal)
        let selectedImage = UIImage(named: TabBarPage.community.pageImageName() + "_on")?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem = UITabBarItem(
            title: TabBarPage.community.pageTitleValue(),
            image: image,
            selectedImage: selectedImage
        )
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showPostDetail(postId: Int) {
        let viewController = dependencies.makeCommunityPostDetailViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

//
//  CommunityFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol CommunityFlowCoordinatorDependencies {
    func makeCommunityViewController(actions: CommunityViewModelActions) -> CommunityViewController
    func makeCommunityPostDetailViewController(post: CommunityPostDTO) -> CommunityPostDetailViewController
    func makeCommunityPostWriteViewController() -> CommunityPostWriteViewController
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
        let actions = CommunityViewModelActions(
            showPostDetail: showPostDetail,
            showPostWrite: showPostWrite
        )
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
    
    private func showPostDetail(post: CommunityPostDTO) {
        let viewController = dependencies.makeCommunityPostDetailViewController(post: post)
        if let communityViewController = navigationController.viewControllers.compactMap({ $0 as? CommunityViewController }).first {
            viewController.delegate = communityViewController
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPostWrite() {
        let viewController = dependencies.makeCommunityPostWriteViewController()
        if let communityViewController = navigationController.viewControllers.compactMap({ $0 as? CommunityViewController }).first {
            viewController.delegate = communityViewController
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}

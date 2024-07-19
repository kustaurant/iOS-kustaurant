//
//  AppFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class AppFlowCoordinator {
    private var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
}

extension AppFlowCoordinator {
    func start() {
        showTab()
    }
}

extension AppFlowCoordinator {
    private func showTab() {
        let tabBarController = UITabBarController()
        let tabBarFlowCoordinator = TabBarFlowCoordinator(
            navigationController: navigationController,
            tabBarController: tabBarController
        )
        
        let homeDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeFlow = homeDIContainer.makeHomeFlowCoordinator(
            appDIContainer: appDIContainer,
            navigationController: UINavigationController(),
            rootNavigationControler: navigationController
        )
        
        let recommendDIContainer = appDIContainer.makeRecommendSceneDIContainer()
        let recommendFlow = recommendDIContainer.makeRecommendFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        let tierDIContainer = appDIContainer.makeTierSceneDIContainer()
        let tierFlow = tierDIContainer.makeTierFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        let communityDIContainer = appDIContainer.makeCommunitySceneDIContainer()
        let communityFlow = communityDIContainer.makeCommunityFlowCoordinator(
            navigationController: UINavigationController()
        )
        
        let myPageDIContainer = appDIContainer.makeMyPageSceneDIContainer()
        let myPageFlow = myPageDIContainer.makeMyPageFlowCoordinator(
            navigationController: UINavigationController()
        )

        tabBarFlowCoordinator.setupTabs(with: [homeFlow, recommendFlow, tierFlow, communityFlow, myPageFlow])
        tabBarFlowCoordinator.configureTabBar()
        tabBarFlowCoordinator.start()
    }
    
    
}

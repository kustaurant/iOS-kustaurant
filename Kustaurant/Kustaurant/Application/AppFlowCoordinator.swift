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
        showOnboarding()
    }
}

// MARK: Onboarding
extension AppFlowCoordinator {
    func showOnboarding() {
        let onboardingDIContainer = appDIContainer.makeOnboardingDIContainer()
        let onboardingCoordinator = onboardingDIContainer.makeOnboardingFlowCoordinator(
            navigationController: navigationController
        )
        
        let initialLaunch = false
        
        if initialLaunch {
            onboardingCoordinator.start()
        } else {
            onboardingCoordinator.showLogin()
        }
    }
}

// MARK: Tabbar
extension AppFlowCoordinator {
    func showTab() {
        let tabBarController = UITabBarController()
        let tabBarFlowCoordinator = TabBarFlowCoordinator(
            navigationController: navigationController,
            tabBarController: tabBarController
        )
        
        let homeDIContainer = appDIContainer.makeHomeSceneDIContainer()
        let homeFlow = homeDIContainer.makeHomeFlowCoordinator(
            appDIContainer: appDIContainer,
            navigationController: CustomUINavigationController(),
            rootNavigationControler: navigationController
        )
        
        let recommendDIContainer = appDIContainer.makeRecommendSceneDIContainer()
        let recommendFlow = recommendDIContainer.makeRecommendFlowCoordinator(
            navigationController: CustomUINavigationController()
        )
        
        let tierDIContainer = appDIContainer.makeTierSceneDIContainer()
        let tierFlow = tierDIContainer.makeTierFlowCoordinator(
            navigationController: CustomUINavigationController()
        )
        
        let communityDIContainer = appDIContainer.makeCommunitySceneDIContainer()
        let communityFlow = communityDIContainer.makeCommunityFlowCoordinator(
            navigationController: CustomUINavigationController()
        )
        
        let myPageDIContainer = appDIContainer.makeMyPageSceneDIContainer()
        let myPageFlow = myPageDIContainer.makeMyPageFlowCoordinator(
            navigationController: CustomUINavigationController()
        )

        tabBarFlowCoordinator.setupTabs(with: [homeFlow, recommendFlow, tierFlow, communityFlow, myPageFlow])
        tabBarFlowCoordinator.configureTabBar()
        tabBarFlowCoordinator.start()
    }
}

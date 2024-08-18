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
        if isLoggedIn() {
            showTab()
        } else {
            showOnboarding()
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
        
        let drawDIContainer = appDIContainer.makeDrawSceneDIContainer()
        let drawFlow = drawDIContainer.makeDrawFlowCoordinator(
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

        tabBarFlowCoordinator.setupTabs(with: [homeFlow, drawFlow, tierFlow, communityFlow, myPageFlow])
        tabBarFlowCoordinator.configureTabBar()
        tabBarFlowCoordinator.start()
    }
}

extension AppFlowCoordinator: OnboardingSceneDelegate {
    
    func showOnboarding() {
        let onboardingDIConatainer = appDIContainer.makeOnboardingDIContainer()
        let onboardingFlow = onboardingDIConatainer.makeOnboardingFlowCoordinator(navigationController: navigationController)
        onboardingFlow.delegate = self
        
        if isIntialLaunch() {
            onboardingFlow.start()
        } else {
            onboardingFlow.showLogin()
        }
    }
        
    func onLoginSuccess() {
        showTab()
    }
}

extension AppFlowCoordinator {
    
    func isIntialLaunch() -> Bool {
        let userDefaultsStorage = appDIContainer.makeUserDefaultsStorage()
        guard let isInitialLaunch: Bool = userDefaultsStorage.getValue(forKey: UserDefaultsKey.initialLaunch) else {
            _ = userDefaultsStorage.setValue(false, forKey: UserDefaultsKey.initialLaunch)
            return true
        }
        return isInitialLaunch
    }
    
    // TODO: 로그인되어 있는지 확인
    func isLoggedIn() -> Bool {
        return false
    }
}

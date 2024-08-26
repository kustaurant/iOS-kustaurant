//
//  AppFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol AppFlowCoordinatorNavigating: AnyObject {
    func showTab()
    func showOnboarding()
}

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
        Task {
            if await isLoggedIn() {
                DispatchQueue.main.async { [weak self] in
                    self?.showTab()
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.showOnboarding()
                }
            }
        }
    }

    func isLoggedIn() async -> Bool {
        let authRepository = DefaultAuthRepository(networkService: appDIContainer.networkService)
        return await authRepository.verifyToken()
    }
}

// MARK: Tabbar
extension AppFlowCoordinator: AppFlowCoordinatorNavigating {
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
        myPageFlow.appFlowNavigating = self
        
        tabBarFlowCoordinator.setupTabs(with: [homeFlow, drawFlow, tierFlow, communityFlow, myPageFlow])
        tabBarFlowCoordinator.configureTabBar()
        tabBarFlowCoordinator.start()
    }
    
    func showOnboarding() {
        let onboardingDIConatainer = appDIContainer.makeOnboardingDIContainer()
        let onboardingFlow = onboardingDIConatainer.makeOnboardingFlowCoordinator(navigationController: navigationController)
        onboardingFlow.appFlowNavigating = self
        
        if isIntialLaunch() {
            onboardingFlow.start()
        } else {
            onboardingFlow.showLogin()
        }
    }
    
        func isIntialLaunch() -> Bool {
        guard let isInitialLaunch: Bool = UserDefaultsStorage.shared.getValue(forKey: UserDefaultsKey.initialLaunch) else {
            UserDefaultsStorage.shared.setValue(false, forKey: UserDefaultsKey.initialLaunch)
            return true
        }
        return isInitialLaunch
    }
    
}

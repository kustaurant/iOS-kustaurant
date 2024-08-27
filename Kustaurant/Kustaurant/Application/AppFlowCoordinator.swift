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
        let skipOnboarding: Bool = UserDefaultsStorage.shared.getValue(forKey: UserDefaultsKey.skipOnboarding) ?? false
        
        if skipOnboarding {
            showTab()
            return
        }
        
        guard let _: UserCredentials = KeychainStorage.shared.getValue(forKey: KeychainKey.userCredentials) else {
            showOnboarding()
            return
        }
        
        Task {
            let isLoggedIn = await isLoggedIn()
            if isLoggedIn {
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
        let verified = await authRepository.verifyToken()
        return verified
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
            appDIContainer: appDIContainer,
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
        
        tabBarFlowCoordinator.setupTabs(with: [myPageFlow, drawFlow, tierFlow, communityFlow, homeFlow])
        tabBarFlowCoordinator.configureTabBar()
        tabBarFlowCoordinator.start()
    }
    
    func showOnboarding() {
        let onboardingDIConatainer = appDIContainer.makeOnboardingDIContainer()
        let onboardingFlow = onboardingDIConatainer.makeOnboardingFlowCoordinator(
            appDIContainer: appDIContainer,
            navigationController: navigationController)
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

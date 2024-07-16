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
        
        tabBarFlowCoordinator.configureTabBar()
        tabBarFlowCoordinator.start()
    }
    
    
}

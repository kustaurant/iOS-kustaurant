//
//  TabBarFlowCoordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class TabBarFlowCoordinator: Coordinator {
    private var tabBarController: UITabBarController
    var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController,
        tabBarController: UITabBarController
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }
}

extension TabBarFlowCoordinator {
    func start() {
        tabBarController.selectedIndex = 0
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    func setupTabs(with coordinators: [Coordinator]) {
        let viewControllers = coordinators.enumerated().map { (index, coordinator) -> UINavigationController in
            coordinator.start()
            return coordinator.navigationController
        }
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBarBackground
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 10, weight: .regular),
            .foregroundColor: UIColor.tabBarTitle
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: 10, weight: .bold),
            .foregroundColor: UIColor.mainGreen
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance

    }
}

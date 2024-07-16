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
        tabBarController.tabBar.backgroundColor = .tabBarBackground
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10),
            .foregroundColor: UIColor.tabBarTitle
        ]

        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10),
            .foregroundColor: UIColor.mainGreen
        ]

        if let items = tabBarController.tabBar.items {
            for item in items {
                item.setTitleTextAttributes(normalAttributes, for: .normal)
                item.setTitleTextAttributes(selectedAttributes, for: .selected)
            }
        }
    }
}

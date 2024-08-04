//
//  MyPageViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    private let tabBarPageController = KuTabBarPageController(
        tabs: [
            KuTabBarPageController.Tab(title: "티어", viewController: FirstVC()),
            KuTabBarPageController.Tab(title: "지도", viewController: FirstVC()),
            KuTabBarPageController.Tab(title: "맛집", viewController: FirstVC()),
            KuTabBarPageController.Tab(title: "평가", viewController: FirstVC()),
        ],
        style: .fill
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(
            tabBarPageController,
            autoLayout: [
                .fillX(0), .topSafeArea(constant: 0), .bottomSafeArea(constant: 0)
            ]
        )
    }
}

class FirstVC: UIViewController {
    private let colors: [UIColor] = [.systemRed, .systemOrange, .systemPink, .systemPurple, .systemCyan, .systemTeal]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors.randomElement()
    }
}

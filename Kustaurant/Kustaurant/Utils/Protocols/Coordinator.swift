//
//  Coordinator.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func pop(animated: Bool = true) {
        if navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
        }
    }
}

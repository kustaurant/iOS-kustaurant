//
//  NavigationBarHideable.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit

protocol NavigationBarHideable {
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(animated: Bool)
}

extension NavigationBarHideable where Self: UIViewController {
    func hideNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

//
//  NavigationBarLeftBackButtonViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import UIKit

class NavigationBarLeftBackButtonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let backButton: UIButton = .init()
        backButton.setImage(UIImage(named: "icon_back"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = buttonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension NavigationBarLeftBackButtonViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

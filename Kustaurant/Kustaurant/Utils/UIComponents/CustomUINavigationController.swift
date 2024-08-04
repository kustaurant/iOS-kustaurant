//
//  CustomUINavigationController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/30/24.
//

import UIKit

final class CustomUINavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
    }

    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        let font = UIFont.Pretendard.semiBold17
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.textBlack
        ]
        appearance.titleTextAttributes = attributes
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}

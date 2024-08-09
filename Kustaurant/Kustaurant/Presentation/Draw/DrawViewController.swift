//
//  RecommendViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit

final class DrawViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

extension DrawViewController {
    
    private func setupNavigationBar() {
        let searchImage = UIImage(named: "icon_search")
        let bellImage = UIImage(named: "icon_bell_badged")
        let searchButtonView = UIImageView(image: searchImage)
        let notificationButtonView = UIImageView(image: bellImage)
        let searchButton = UIBarButtonItem(customView: searchButtonView)
        let notificationButton = UIBarButtonItem(customView: notificationButtonView)
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 16.0
        navigationItem.title = "랜덤 맛집 뽑기"
        navigationItem.rightBarButtonItems = [searchButton, space, notificationButton]
    }
}

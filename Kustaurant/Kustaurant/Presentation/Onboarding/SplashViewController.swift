//
//  SplashViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/6/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let viewModel: SplashViewModel
    private let splashView = SplashView()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("fail to initialize SplashViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = splashView
    }
}

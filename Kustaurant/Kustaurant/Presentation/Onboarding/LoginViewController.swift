//
//  LoginViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/8/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = loginView
    }
}

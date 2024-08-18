//
//  LoginViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/8/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let viewModel: OnboardingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
    }
    
    override func loadView() {
        view = loginView
    }
}

extension LoginViewController {
    
    private func bindViews() {
        
        loginView.socialLoginView.naverLoginButton.tapPublisher().sink { [weak self] in
            self?.viewModel.naverLogin()
        }
        .store(in: &cancellables)
        
        loginView.socialLoginView.appleLoginButton.tapPublisher().sink { [weak self] in
            self?.viewModel.appleLogin()
        }
        .store(in: &cancellables)
    }
}

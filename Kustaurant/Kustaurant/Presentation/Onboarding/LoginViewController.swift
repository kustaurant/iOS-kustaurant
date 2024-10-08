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
        bind()
        bindViews()
    }
    
    override func loadView() {
        view = loginView
    }
}

extension LoginViewController {
    
    private func bind() {
        viewModel.showAlertPublisher.sink { [weak self] showAlert in
            if showAlert {
                self?.presentAlert()
            }
        }
        .store(in: &cancellables)
    }
    
    private func bindViews() {
        
        loginView.socialLoginView.naverLoginButton.tapPublisher().sink { [weak self] in
            self?.viewModel.naverLogin()
        }
        .store(in: &cancellables)
        
        loginView.socialLoginView.appleLoginButton.tapPublisher().sink { [weak self] in
            self?.viewModel.appleLogin()
        }
        .store(in: &cancellables)
        
        loginView.socialLoginView.skipButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.skipLogin()
            }, for: .touchUpInside)
    }
}

extension LoginViewController {
    
    private func presentAlert() {
        let alert = UIAlertController(title: "로그인에 실패했습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.viewModel.didTapOkInAlert()
        }))
        present(alert, animated: true, completion: nil)
    }
}

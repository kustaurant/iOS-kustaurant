//
//  ProfileComposeViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit
import Combine

class ProfileComposeViewController: UIViewController {
    
    private let profileComposeView = ProfileComposeView()
    private var viewModel: ProfileComposeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var textFieldHandler: ProfileComposeTextFieldHandler?
    
    init(viewModel: ProfileComposeViewModel) {
        self.viewModel = viewModel
        self.textFieldHandler = .init(view: profileComposeView, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupKeyboardEndGesture()
        textFieldHandler?.setupTextFields()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserProfile()
    }
    
    override func loadView() {
        view = profileComposeView
    }
}

extension ProfileComposeViewController {
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "icon_back")
        let backButtonView = UIImageView(image: backImage)
        let backButton = UIBarButtonItem(customView: backButtonView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        backButtonView.isUserInteractionEnabled = true
        navigationItem.title = "프로필 편집"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
    
    private func setupKeyboardEndGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        profileComposeView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        profileComposeView.endEditing(true)
    }
}

extension ProfileComposeViewController {
    
    private func bind() {
        viewModel.userProfilePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userProfile in
                self?.textFieldHandler?.fillTextFields(with: userProfile)
            }
            .store(in: &cancellables)
        
        viewModel.nicknameErrorPublisher.sink { [weak self] error in
            switch error {
            case .invalidPhoneNumber:
                self?.profileComposeView.nicknameTextField.errorText = ProfileComposeTextFieldError.invalidPhoneNumber.rawValue
            case .nicknameTooLong:
                self?.profileComposeView.nicknameTextField.errorText = ProfileComposeTextFieldError.nicknameTooLong.rawValue
            case .phoneNumberTooLong:
                self?.profileComposeView.phoneNumberTextField.errorText = ProfileComposeTextFieldError.phoneNumberTooLong.rawValue
            case .none:
                self?.profileComposeView.nicknameTextField.errorText = ""
            }
        }
        .store(in: &cancellables)
        
        viewModel.showAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showAlert in
            if showAlert {
                self?.presentAlert()
            }
        }
        .store(in: &cancellables)
        
        profileComposeView.submitButton.tapPublisher()
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.viewModel.didTapSubmitButton()
        }
        .store(in: &cancellables)
    }
}

extension ProfileComposeViewController {
    
    private func presentAlert() {
        let alert = UIAlertController(title: viewModel.alertPayload.title, message: viewModel.alertPayload.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.viewModel.alertPayload.onConfirm?()
        }))
        present(alert, animated: true, completion: nil)
    }
}

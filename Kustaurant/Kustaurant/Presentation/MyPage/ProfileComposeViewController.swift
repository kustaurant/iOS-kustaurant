//
//  ProfileComposeViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit
import Combine

class ProfileComposeViewController: NavigationBarLeftBackButtonViewController {
    
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
        setupKeyboardEndGesture()
        setupProfileImage()
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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "프로필 편집"
    }
}

extension ProfileComposeViewController {
    
    private func setupProfileImage() {
        if let imgUrlString = viewModel.profileImgUrl,
           let imgUrl = URL(string: imgUrlString) {
            Task {
                let image = await ImageCacheManager.shared.loadImage(
                    from: imgUrl,
                    targetSize: CGSize(width: 90, height: 90),
                    defaultImage: UIImage(named: "img_babycow")
                )
                await MainActor.run {
                    profileComposeView.profileImageView.image = image
                }
            }
        }
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
            case .nicknameTooLong:
                self?.profileComposeView.nicknameTextField.errorText = ProfileComposeTextFieldError.nicknameTooLong.rawValue
            default:
                self?.profileComposeView.nicknameTextField.errorText = ""
                
            }
        }
        .store(in: &cancellables)
        
        viewModel.phoneNumberErrorPublisher.sink { [weak self] error in
            switch error {
            case .invalidPhoneNumber:
                self?.profileComposeView.nicknameTextField.errorText = ProfileComposeTextFieldError.invalidPhoneNumber.rawValue
            case .phoneNumberTooLong:
                self?.profileComposeView.phoneNumberTextField.errorText = ProfileComposeTextFieldError.phoneNumberTooLong.rawValue
            default:
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

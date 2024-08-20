//
//  OnboardingViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import UIKit
import Combine

class OnboardingViewController: UIViewController {
    
    private var viewModel: OnboardingViewModel
    private let onboardingView = OnboardingView()
    private var onboardingCollectionViewHandler: OnboardingCollectionViewHandler?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        onboardingCollectionViewHandler = OnboardingCollectionViewHandler(
            view: onboardingView,
            viewModel: viewModel
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingCollectionViewHandler?.setupCollectionView()
        onboardingCollectionViewHandler?.setupPageControl()
        bind()
        bindViews()
    }
    
    override func loadView() {
        view = onboardingView
    }
}

extension OnboardingViewController {
    
    private func bind() {
        viewModel.showAlertPublisher.sink { [weak self] showAlert in
            if showAlert {
                self?.presentAlert()
            }
        }
        .store(in: &cancellables)
    }
    
    private func bindViews() {
        viewModel.currentOnboardingPagePublisher.sink { [weak self] page in
            self?.onboardingView.pageControl.currentPage = page
        }
        .store(in: &cancellables)
        
        onboardingView.socialLoginView.naverLoginButton.tapPublisher().sink { [weak self] in
            self?.viewModel.naverLogin()
        }
        .store(in: &cancellables)
        
        onboardingView.socialLoginView.appleLoginButton.tapPublisher().sink { [weak self] in
            self?.viewModel.appleLogin()
        }
        .store(in: &cancellables)
        
        onboardingView.socialLoginView.skipButton.tapPublisher().sink { [weak self] in
            self?.viewModel.skipLogin()
        }
        .store(in: &cancellables)
    }
}


extension OnboardingViewController {
    
    private func presentAlert() {
        let alert = UIAlertController(title: "로그인에 실패했습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.viewModel.didTapOkInAlert()
        }))
        present(alert, animated: true, completion: nil)
    }
}

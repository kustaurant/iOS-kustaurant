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
        bindViews()
    }
    
    override func loadView() {
        view = onboardingView
    }
}

extension OnboardingViewController {
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
        
        // MARK: 네이버 로그아웃 테스트 버튼
        onboardingView.socialLoginView.skipButton.tapPublisher().sink { [weak self] in
            self?.viewModel.naverLogout()
        }
        .store(in: &cancellables)
    }
}

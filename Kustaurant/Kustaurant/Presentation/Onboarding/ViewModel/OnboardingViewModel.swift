//
//  OnboardingViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import Foundation
import Combine

struct OnboardingViewModelActions {
    let initiateTabs: (() -> Void)?
}

protocol OnboardingViewModelInput {
    func naverLogin()
    func appleLogin()
    func logout()
    func skipLogin()
    func didTapOkInAlert()
}

protocol OnboardingViewModelOutput {
    var onboardingContents: [OnboardingContent] { get }
    var currentOnboardingPage: Int { get set }
    var currentOnboardingPagePublisher: Published<Int>.Publisher { get }
    var isUpdatingPage: Bool { get set }
    var showAlert: Bool { get set }
    var showAlertPublisher: Published<Bool>.Publisher { get }
}

typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

final class DefaultOnboardingViewModel {
    let onboardingContents = OnboardingContent.all()
    @Published var currentOnboardingPage: Int = 0
    var currentOnboardingPagePublisher: Published<Int>.Publisher { $currentOnboardingPage }
    @Published var isUpdatingPage: Bool = false
    @Published var showAlert: Bool = false
    var showAlertPublisher: Published<Bool>.Publisher { $showAlert }
    
    private let actions: OnboardingViewModelActions
    private let authUseCases: AuthUseCases
    private var cancellables = Set<AnyCancellable>()
    
    init(actions: OnboardingViewModelActions, onboardingUseCases: AuthUseCases) {
        self.actions = actions
        self.authUseCases = onboardingUseCases
    }
}

extension DefaultOnboardingViewModel: OnboardingViewModel {
    
    func naverLogin() {
        authUseCases.naverLogin()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(#file, #function, error.localizedDescription)
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] user in
                self?.actions.initiateTabs?()
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        authUseCases.logout()
    }
    
    func appleLogin() {
        authUseCases.appleLogin()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(#file, #function, error.localizedDescription)
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] user in
                self?.actions.initiateTabs?()
            }
            .store(in: &cancellables)
    }
    
    func skipLogin() {
        authUseCases.skipLogin()
        actions.initiateTabs?()
    }
    
    func didTapOkInAlert() {
        showAlert = false
    }
}

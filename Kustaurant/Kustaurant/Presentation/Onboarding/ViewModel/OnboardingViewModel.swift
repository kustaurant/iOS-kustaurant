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
}

protocol OnboardingViewModelOutput {
    var onboardingContents: [OnboardingContent] { get }
    var currentOnboardingPage: Int { get set }
    var currentOnboardingPagePublisher: Published<Int>.Publisher { get }
    var isUpdatingPage: Bool { get set }
}

typealias OnboardingViewModel = OnboardingViewModelInput & OnboardingViewModelOutput

final class DefaultOnboardingViewModel: OnboardingViewModel {
    let onboardingContents = OnboardingContent.all()
    @Published var currentOnboardingPage: Int = 0
    var currentOnboardingPagePublisher: Published<Int>.Publisher { $currentOnboardingPage }
    @Published var isUpdatingPage: Bool = false
    
    private let actions: OnboardingViewModelActions
    private let authUseCases: AuthUseCases
    private var cancellables = Set<AnyCancellable>()
    
    init(actions: OnboardingViewModelActions, onboardingUseCases: AuthUseCases) {
        self.actions = actions
        self.authUseCases = onboardingUseCases
    }
    
    func naverLogin() {
        authUseCases.naverLogin()
            .receive(on: DispatchQueue.main)
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(#file, #function, error.localizedDescription)
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
            .sink { [weak self] user in
                self?.actions.initiateTabs?()
                print(user)
            }
            .store(in: &cancellables)
    }
}

//
//  OnboardingViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import Foundation
import Combine

struct OnboardingViewModelActions {
}

protocol OnboardingViewModelInput {
    func naverLogin()
    func naverLogout()
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
    
    private let onboardingUseCases: OnboardingUseCases
    private var cancellables = Set<AnyCancellable>()
    
    init(onboardingUseCases: OnboardingUseCases) {
        self.onboardingUseCases = onboardingUseCases
    }
    
    func naverLogin() {
        onboardingUseCases.naverLogin().sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(#file, #function, error.localizedDescription)
            }
        } receiveValue: { user in
            // 홈 화면 이동
            print(user)
        }
        .store(in: &cancellables)
    }
    
    func naverLogout() {
        onboardingUseCases.naverLogout()
    }
}

//
//  OnboardingViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import Foundation

struct OnboardingViewModelActions {
}

protocol OnboardingViewModelInput {}

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
    
    init() {}
}

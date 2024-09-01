//
//  FeedbackSubmittingViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import Foundation
import Combine

struct FeedbackSubmittingViewModelActions {
    let pop: () -> Void
}

protocol FeedbackSubmittingViewModelInput {
    func didTapBackButton()
    func textViewFocused(_ value: Bool)
    func updateFeedbackText(_ text: String)
    func didTapSubmitButton()
    func didTapOkInAlert()
}

protocol FeedbackSubmittingViewModelOutput {
    var maxTextCount: Int { get }
    var textViewFocused: Bool { get }
    var textViewFocusedPublisher: Published<Bool>.Publisher { get }
    var feedbackText: String { get }
    var feedbackTextPublisher: Published<String>.Publisher { get }
    var showAlert: Bool { get }
    var showAlertPublisher: Published<Bool>.Publisher { get }
}

typealias FeedbackSubmittingViewModel = FeedbackSubmittingViewModelInput & FeedbackSubmittingViewModelOutput

final class DefaultFeedbackSubmittingViewModel: FeedbackSubmittingViewModel {
    var maxTextCount = 300
    
    @Published var showAlert: Bool = false
    var showAlertPublisher: Published<Bool>.Publisher { $showAlert }
    @Published var textViewFocused: Bool = false
    var textViewFocusedPublisher: Published<Bool>.Publisher { $textViewFocused }
    @Published var feedbackText: String = ""
    var feedbackTextPublisher: Published<String>.Publisher { $feedbackText }
    
    private let actions: FeedbackSubmittingViewModelActions
    private let myPageUseCases: MyPageUseCases
    
    init(actions: FeedbackSubmittingViewModelActions, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultFeedbackSubmittingViewModel {
    
    func textViewFocused(_ value: Bool) {
        textViewFocused = value
    }
    
    func didTapBackButton() {
        actions.pop()
    }
    
    func updateFeedbackText(_ text: String) {
        feedbackText = text
    }
    
    func didTapSubmitButton() {
        Task {
            let result = await myPageUseCases.sendFeedback(feedbackText)
            switch result {
            case .success:
                showAlert = true
            case .failure:
                break
            }
        }
    }
    
    func didTapOkInAlert() {
        showAlert = false
        feedbackText = ""
    }
}

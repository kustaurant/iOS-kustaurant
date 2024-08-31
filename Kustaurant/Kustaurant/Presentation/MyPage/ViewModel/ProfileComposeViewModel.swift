//
//  ProfileComposeViewModel.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import Foundation
import Combine

struct ProfileComposeViewModelActions {
    let pop: () -> Void
}

protocol ProfileComposeViewModelInput {
    func didTapBackButton()
    func didTapSubmitButton()
    func updateNicknameText(_ text: String)
    func updatePhoneNumberText(_ text: String)
    func updateNicknameError(_ error: ProfileComposeTextFieldError)
    func updatePhoneNumberError(_ error: ProfileComposeTextFieldError)
}

protocol ProfileComposeViewModelOutput {
    var nicknameText: String { get }
    var nicknameTextPublisher: Published<String>.Publisher { get }
    var nicknameError: ProfileComposeTextFieldError { get }
    var nicknameErrorPublisher: Published<ProfileComposeTextFieldError>.Publisher { get }
    var phoneNumberText: String { get }
    var phoneNumberTextPublisher: Published<String>.Publisher { get }
    var phoneNumberError: ProfileComposeTextFieldError { get }
    var phoneNumberErrorPublisher: Published<ProfileComposeTextFieldError>.Publisher { get }
    var showAlert: Bool { get }
    var showAlertPublisher: Published<Bool>.Publisher { get }
    var alertPayload: AlertPayload { get }
}

typealias ProfileComposeViewModel = ProfileComposeViewModelInput & ProfileComposeViewModelOutput

final class DefaultProfileComposeViewModel: ProfileComposeViewModel {
    @Published var nicknameError: ProfileComposeTextFieldError = .none
    var nicknameErrorPublisher: Published<ProfileComposeTextFieldError>.Publisher { $nicknameError }
    @Published var phoneNumberError: ProfileComposeTextFieldError = .none
    var phoneNumberErrorPublisher: Published<ProfileComposeTextFieldError>.Publisher { $phoneNumberError }
    
    @Published var nicknameText: String = ""
    var nicknameTextPublisher: Published<String>.Publisher { $nicknameText }
    @Published var phoneNumberText: String = ""
    var phoneNumberTextPublisher: Published<String>.Publisher { $phoneNumberText }
    
    @Published var showAlert: Bool = false
    var showAlertPublisher: Published<Bool>.Publisher { $showAlert }
    @Published var alertPayload: AlertPayload = AlertPayload.empty()
    
    private let actions: ProfileComposeViewModelActions
    private let myPageUseCases: MyPageUseCases
    
    init(actions: ProfileComposeViewModelActions, myPageUseCases: MyPageUseCases) {
        self.actions = actions
        self.myPageUseCases = myPageUseCases
    }
}

extension DefaultProfileComposeViewModel {
    
    func didTapBackButton() {
        actions.pop()
    }
    
    func didTapSubmitButton() {
        Task {
            let result = await myPageUseCases.updateUserPrfile(UserProfile(nickname: nicknameText, phoneNumber: phoneNumberText))
            switch result {
            case .success:
                alertPayload = AlertPayload(title: "프로필을 편집했습니다.", subtitle: "", onConfirm: dismissAlert)
            case .failure(let failure):
                switch failure {
                case .custom(let error):
                    alertPayload = AlertPayload(title: error, subtitle: "", onConfirm: {})
                default:
                    alertPayload = AlertPayload(title: "프로필 편집에 실패했습니다.", subtitle: "", onConfirm: dismissAlert)
                }
            }
            showAlert = true
        }
    }
    
    func dismissAlert() {
        showAlert = false
        alertPayload = AlertPayload.empty()
    }
    
    func updateNicknameText(_ text: String) {
        nicknameText = text
    }
    
    func updatePhoneNumberText(_ text: String) {
        phoneNumberText = text
    }
    
    func updateNicknameError(_ error: ProfileComposeTextFieldError) {
        nicknameError = error
    }
    
    func updatePhoneNumberError(_ error: ProfileComposeTextFieldError) {
        phoneNumberError = error
    }
}
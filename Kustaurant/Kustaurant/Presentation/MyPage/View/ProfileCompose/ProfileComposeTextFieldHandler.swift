//
//  ProfileComposeTextFieldHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit

enum ProfileComposeTextFieldError: String {
    case none = ""
    case nicknameTooLong = "닉네임은 최대 25자까지 설정할 수 있습니다."
    case invalidPhoneNumber = "연락처에는 '-' 을 제외한 숫자만 입력 가능합니다."
    case phoneNumberTooLong = "연락처에는 최대 10자까지 입력할 수 있습니다."
}

enum ProfileComposeTextFieldTag: Int {
    case nickname = 1
    case email = 2
    case phoneNumber = 3
}

final class ProfileComposeTextFieldHandler: NSObject {
    
    static let nicknameMaxLength = 25
    static let phoneNumberMaxLength = 11
    
    private let view: ProfileComposeView
    private let viewModel: ProfileComposeViewModel
    
    init(view: ProfileComposeView, viewModel: ProfileComposeViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
    
    func setupTextFields() {
        view.nicknameTextField.textField.delegate = self
        view.phoneNumberTextField.textField.delegate = self
        view.nicknameTextField.textField.tag = ProfileComposeTextFieldTag.nickname.rawValue
        view.emailTextField.textField.tag = ProfileComposeTextFieldTag.email.rawValue
        view.phoneNumberTextField.textField.tag = ProfileComposeTextFieldTag.phoneNumber.rawValue
    }
}

extension ProfileComposeTextFieldHandler: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let tag = ProfileComposeTextFieldTag(rawValue: textField.tag) else { return false }
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        switch tag {
        case .nickname:
            if validateNicknameTextField(newText) {
                viewModel.updateNicknameText(newText)
                return true
            } else {
                return false
            }
        case .email:
            return false
        case .phoneNumber:
            if validatePhoneNumber(newText, replacementString: string) {
                viewModel.updatePhoneNumberText(newText)
                return true
            } else {
                return false
            }
        }
    }
}

extension ProfileComposeTextFieldHandler {
    
    func fillTextFields(with userProfile: UserProfile) {
        view.nicknameTextField.textField.text = userProfile.nickname
        view.emailTextField.textField.text = userProfile.email
        view.phoneNumberTextField.textField.text = userProfile.phoneNumber
    }
    
    private func validateNicknameTextField(_ text: String) -> Bool {
        if text.count > ProfileComposeTextFieldHandler.nicknameMaxLength {
            viewModel.updateNicknameError(.nicknameTooLong)
            return false
        }
        
        viewModel.updateNicknameError(.none)
        return true
    }
    
    private func validatePhoneNumber(_ text: String, replacementString string: String) -> Bool {
        if text.count > ProfileComposeTextFieldHandler.phoneNumberMaxLength {
            viewModel.updatePhoneNumberError(.phoneNumberTooLong)
            return false
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) {
            viewModel.updatePhoneNumberError(.invalidPhoneNumber)
            return false
        }
        
        viewModel.updatePhoneNumberError(.none)
        return true
    }
}

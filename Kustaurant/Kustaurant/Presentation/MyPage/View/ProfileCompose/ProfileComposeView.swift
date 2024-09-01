//
//  ProfileComposeView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit

class ProfileComposeView: UIView {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "img_babycow")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 39
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let nicknameTextField: KuTextField = {
        let tf = KuTextField(topLabelText: "닉네임", placeholder: "닉네임을 입력해주세요.")
        tf.bottomLabelText = "닉네임은 30일에 한 번 변경할 수 있습니다."
        tf.textField.keyboardType = .default
        return tf
    }()
    
    let emailTextField: KuTextField = {
        let tf = KuTextField(topLabelText: "이메일", placeholder: "")
        tf.textFieldEnabled = false
        return tf
    }()
    
    let phoneNumberTextField: KuTextField = {
        let tf = KuTextField(topLabelText: "연락처", placeholder: "연락처를 입력해주세요(‘-’제외)")
        tf.bottomLabelText = "이벤트 쿠폰 수신을 위해 핸드폰 번호를 입력해주세요."
        tf.textField.keyboardType = .numberPad
        return tf
    }()
    
    let submitButton: KuSubmitButton = {
        let button = KuSubmitButton()
        button.buttonState = .on
        button.buttonTitle = "저장하기"
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileComposeView {
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(profileImageView, autoLayout: [.topSafeArea(constant: 26), .centerX(0), .width(78), .height(78)])
        addSubview(nicknameTextField, autoLayout: [.topNext(to: profileImageView, constant: 14), .fillX(20), .height(103), .centerX(0)])
        addSubview(emailTextField, autoLayout: [.topNext(to: nicknameTextField, constant: 14), .fillX(20), .height(103), .centerX(0)])
        addSubview(phoneNumberTextField, autoLayout: [.topNext(to: emailTextField, constant: 14), .fillX(20), .height(103), .centerX(0)])
        addSubview(submitButton, autoLayout: [.bottomSafeArea(constant: 20), .fillX(20), .height(52)])
    }
}

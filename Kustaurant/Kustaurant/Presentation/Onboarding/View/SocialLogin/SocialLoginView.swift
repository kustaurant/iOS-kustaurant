//
//  LoginView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/8/24.
//

import UIKit

enum SocialLoginViewTheme {
    case light, dark
}

class SocialLoginView: UIView {
    
    private var theme: SocialLoginViewTheme?

    private let dividerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var leftDivider: UIView = {
        let view = UIView()
        view.backgroundColor = theme == .light ? .Sementic.gray200 : .Sementic.gray600
        return view
    }()
    
    private lazy var rightDivider: UIView = {
        let view = UIView()
        view.backgroundColor = theme == .light ? .Sementic.gray200 : .Sementic.gray600
        return view
    }()
    
    private let socialLoginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "간편 로그인"
        label.font = .Pretendard.medium12
        label.textColor = .Sementic.gray300
        return label
    }()
    
    private let loginButtonsView: UIView = {
        let view = UIView()
        return view
    }()
    
    let naverLoginButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "icon_naver_login")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        let image = self.theme == .dark ? UIImage(named: "icon_apple_login_white") : UIImage(named: "icon_apple_login_black")
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        let underlineAttriString1 = NSAttributedString(
            string: "건너뛰기",
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        let titleColor: UIColor? = theme == .light ? .Sementic.gray600 : .Sementic.gray300
        button.setAttributedTitle(underlineAttriString1, for: .normal)
        button.titleLabel?.font = .Pretendard.regular12
        button.setTitleColor(titleColor, for: .normal)
        button.isHidden = true
        return button
    }()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(_ theme: SocialLoginViewTheme = .light) {
        super.init(frame: .zero)
        self.theme = theme
        commonInit()
    }
    
    private func commonInit() {
        setupDivider()
        setupLoginButtons()
        setupSkipButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocialLoginView {
    
    private func setupDivider() {
        addSubview(dividerView, autoLayout: [.top(0), .leading(0), .trailing(0)])
        dividerView.addSubview(leftDivider, autoLayout: [.leading(0), .centerY(0), .height(2)])
        dividerView.addSubview(socialLoginLabel, autoLayout: [.leadingNext(to: leftDivider, constant: 8), .centerY(0), .centerX(0)])
        dividerView.addSubview(rightDivider, autoLayout: [.leadingNext(to: socialLoginLabel, constant: 8), .trailing(0), .centerY(0), .height(2)])
    }
    
    private func setupLoginButtons() {
        
        addSubview(
            loginButtonsView,
            autoLayout: [
                .topNext(to: dividerView, constant: 16),
                .leading(88),
                .trailing(88),
                .centerY(0),
                .height(58)
            ]
        )
        
        loginButtonsView.addSubview(naverLoginButton, autoLayout: [.leading(0)])
        loginButtonsView.addSubview(appleLoginButton, autoLayout: [.trailing(0)])
    }
    
    private func setupSkipButton() {
        addSubview(skipButton, autoLayout: [.topNext(to: loginButtonsView, constant: 16), .leading(88), .trailing(88)])
    }
}

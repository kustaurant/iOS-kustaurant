//
//  LoginView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/8/24.
//

import UIKit

class LoginView: UIView {
    
    private let loginBlurredImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "img_login_blurred")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let logoContainerView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    
    private let kuLogoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icon_ku_fill")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let kuTextImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "text_ku_fill")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "건대생을 위한 맛집 리스트"
        label.font = .Pretendard.semiBold20
        label.textColor = .Signature.green100
        label.textAlignment = .center
        return label
    }()
    
    let socialLoginView: SocialLoginView = {
        let view = SocialLoginView(.dark)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    
    private func setupUI() {
        backgroundColor = .black
        addSubview(loginBlurredImageView, autoLayout: [.top(0), .fillX(0), .height(UIScreen.main.bounds.height * 0.66)])
        loginBlurredImageView.addSubview(logoContainerView, autoLayout: [.fillX(0), .bottomEqual(to: loginBlurredImageView, constant: 0)])
        logoContainerView.addArrangedSubview(kuLogoImageView)
        logoContainerView.addArrangedSubview(kuTextImageView)
        addSubview(appDescriptionLabel, autoLayout: [.topNext(to: logoContainerView, constant: 16), .fillX(0)])
        addSubview(socialLoginView, autoLayout: [.topNext(to: appDescriptionLabel, constant: 32), .leading(32), .trailing(32), .bottom(28)])
    }
}


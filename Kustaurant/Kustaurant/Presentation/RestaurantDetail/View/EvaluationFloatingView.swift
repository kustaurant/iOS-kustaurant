//
//  AffiliabteFloatingView.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit

final class EvaluationFloatingView: UIView {
    
    private let evaluateButton: KuSubmitButton = .init()
    private let favoriteButton: UIButton = .init()
    private var favoriteButtonConfiguration = UIButton.Configuration.plain()
    var onTapEvaluateButton: (() -> Void)?
    var onTapFavoriteButton: (() -> Void)?
    
    var loginStatus: LoginStatus = .notLoggedIn {
        didSet {
            evaluateButton.buttonState = loginStatus == .loggedIn ? .on : .off
            favoriteButton.isEnabled = loginStatus == .loggedIn ? true : false
        }
    }
    
    var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "icon_star_enabled" : "icon_star_disabled"
            configureFavoriteButton(with: UIImage(named: imageName))
        }
    }
    
    var evaluationCount: Int = 0 {
        didSet {
            configureFavoriteButton(with: "\(evaluationCount)명")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupEvaluateButton()
        setupFavoriteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EvaluationFloatingView {
    
    @objc private func didTapEvaluateButton() {
        onTapEvaluateButton?()
    }
    
    @objc private func didFavoriteButton() {
        onTapFavoriteButton?()
    }
    
    private func setupLayout() {
        backgroundColor = .white
        addSubview(evaluateButton, autoLayout: [.leading(16), .height(52), .top(12)])
        addSubview(favoriteButton, autoLayout: [.leadingNext(to: evaluateButton, constant: 8), .centerY(0), .trailing(22), .height(48)])
    }
    
    private func setupEvaluateButton() {
        evaluateButton.buttonTitle = "맛집 평가하기"
        evaluateButton.addTarget(self, action: #selector(didTapEvaluateButton), for: .touchUpInside)
    }
    
    private func setupFavoriteButton() {
        favoriteButton.configuration = favoriteButtonConfiguration
        favoriteButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        favoriteButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        favoriteButton.addTarget(self, action: #selector(didFavoriteButton), for: .touchUpInside)
    }
    
    private func configureFavoriteButton(with image: UIImage?) {
        favoriteButtonConfiguration.image = image
        favoriteButtonConfiguration.imagePadding = 8
        favoriteButtonConfiguration.imagePlacement = .top
        favoriteButtonConfiguration.baseForegroundColor = .Sementic.gray600
        setupFavoriteButton()
    }
    
    private func configureFavoriteButton(with text: String?) {
        favoriteButtonConfiguration.title = text
        let titleAttributes = AttributeContainer([
            .font: UIFont.Pretendard.regular12,
            .foregroundColor: UIColor.Sementic.gray600 ?? .lightGray
        ])
        favoriteButtonConfiguration.attributedTitle = AttributedString(text ?? "", attributes: titleAttributes)
        setupFavoriteButton()
    }
}

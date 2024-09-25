//
//  AffiliabteFloatingView.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit

extension EvaluationFloatingView {
    enum ViewType {
        case detail, evaluation
    }
}

final class EvaluationFloatingView: UIView {
    
    private var viewType: ViewType
    private let containerView: UIView = .init()
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
    
    init(viewType: ViewType) {
        self.viewType = viewType
        super.init(frame: .zero)
        setupLayout()
        setupEvaluateButton()
        setupFavoriteButton()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeEvaluateState(_ onOff: KuSubmitButton.ButtonState) {
        evaluateButton.buttonState = onOff
    }
    
    static func getHeight() -> CGFloat {
        let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow }
        let bottomSafeAreaHeight = window?.safeAreaInsets.bottom ?? 0
        return 68 + (bottomSafeAreaHeight == 0 ? 16 : bottomSafeAreaHeight)
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
        containerView.backgroundColor = .white
        let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow }        
        let bottomSafeAreaHeight = window?.safeAreaInsets.bottom ?? 0
        addSubview(containerView, autoLayout: [.fill(0), .height(EvaluationFloatingView.getHeight())])
        
        switch viewType {
        case .detail:
            containerView.addSubview(evaluateButton, autoLayout: [.leading(16), .height(52), .top(16)])
            containerView.addSubview(favoriteButton, autoLayout: [.leadingNext(to: evaluateButton, constant: 8), .centerY(0), .trailing(22), .height(48)])
        case .evaluation:
            containerView.addSubview(evaluateButton, autoLayout: [.fillX(20), .height(52), .top(16)])
        }
        
    }
    
    private func setupEvaluateButton() {
        evaluateButton.buttonTitle = (viewType == .detail) ? "맛집 평가하기" : "평가 제출하기"
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

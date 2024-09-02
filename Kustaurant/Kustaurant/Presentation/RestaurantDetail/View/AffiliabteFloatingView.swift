//
//  AffiliabteFloatingView.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/2/24.
//

import UIKit

final class AffiliabteFloatingView: UIView {
    
    private let evaluateButton: KuSubmitButton = .init()
    private let likeButton: UIButton = .init()
    private var likeButtonConfiguration = UIButton.Configuration.plain()
    var onTapEvaluateButton: (() -> Void)?
    
    var evaluateButtonStatus: KuSubmitButton.ButtonState? {
        didSet {
            evaluateButton.buttonState = evaluateButtonStatus ?? .off
        }
    }
    
    var likeButtonImageName: String? {
        didSet {
            configureLikeButton(with: UIImage(named: likeButtonImageName ?? "icon_star_disabled"))
        }
    }
    
    var likeButtonText: String? {
        didSet {
            configureLikeButton(with: likeButtonText)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupEvaluateButton()
        setupLikeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AffiliabteFloatingView {
    
    @objc private func didTapEvaluateButton() {
        onTapEvaluateButton?()
    }
    
    private func setupLayout() {
        addSubview(evaluateButton, autoLayout: [.leading(16), .height(52), .top(12)])
        addSubview(likeButton, autoLayout: [.leadingNext(to: evaluateButton, constant: 8), .topEqual(to: evaluateButton, constant: 0), .trailing(22), .height(52)])
    }
    
    private func setupEvaluateButton() {
        evaluateButton.buttonTitle = "맛집 평가하기"
        evaluateButton.addTarget(self, action: #selector(didTapEvaluateButton), for: .touchUpInside)
    }
    
    private func setupLikeButton() {
        likeButton.configuration = likeButtonConfiguration
    }
    
    private func configureLikeButton(with image: UIImage?) {
        likeButtonConfiguration.image = image
        likeButtonConfiguration.imagePadding = 8
        likeButtonConfiguration.imagePlacement = .top
        likeButtonConfiguration.baseForegroundColor = .Sementic.gray600
        setupLikeButton()
    }
    
    private func configureLikeButton(with text: String?) {
        likeButtonConfiguration.title = text
        let titleAttributes = AttributeContainer([
            .font: UIFont.Pretendard.regular12,
            .foregroundColor: UIColor.Sementic.gray600 ?? .lightGray
        ])
        likeButtonConfiguration.attributedTitle = AttributedString(text ?? "", attributes: titleAttributes)
        setupLikeButton()
    }
}

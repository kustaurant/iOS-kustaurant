//
//  CommentAccessoryView.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/5/24.
//

import UIKit
import Combine


final class CommentAccessoryView: UIView {
    
    let textField: UITextField = .init()
    let sendButton: UIButton = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentAccessoryView {
    
    func sendButtonTapPublisher() -> AnyPublisher<Void, Never> {
        return sendButton.tapPublisher()

    }
    
    private func setupLayout() {
        let containerView = UIStackView()
        containerView.spacing = 6
        containerView.distribution = .fillProportionally
        containerView.alignment = .center
        containerView.addArrangedSubview(textField)
        containerView.addArrangedSubview(sendButton)
        textField.autolayout([.height(45)])
        sendButton.autolayout([.width(42), .height(46)])
        addSubview(containerView, autoLayout: [.fillY(0), .fillX(12)])
    }
    
    private func setupStyle() {
        backgroundColor = .white
        textField.backgroundColor = .Sementic.gray100
        textField.layer.cornerRadius = 20
        textField.layer.cornerCurve = .continuous
        textField.clipsToBounds = true
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 45))
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 45))
        textField.leftView = paddingViewLeft
        textField.rightView = paddingViewRight
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        sendButton.setImage(UIImage(named: "icon_paperplane"), for: .normal)
    }
}

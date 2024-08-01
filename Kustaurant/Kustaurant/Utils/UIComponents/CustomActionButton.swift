//
//  CustomActionButton.swift
//  Kustaurant
//
//  Created by 송우진 on 8/1/24.
//

import UIKit

final class CustomActionButton: UIButton {
    enum ButtonState {
        case on, off
    }
    
    var buttonState: ButtonState = .off {
        didSet {
            updateStyle()
        }
    }
    
    var buttonTitle: String = "" {
        didSet {
            updateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        self.configuration = configuration
        updateStyle()
    }
    
    private func updateStyle() {
        var configuration = self.configuration
        configuration?.title = buttonTitle
        configuration?.attributedTitle = AttributedString(buttonTitle, attributes: AttributeContainer(
            [.font: UIFont.pretendard(size: 18, weight: .semibold)]
        ))
        switch buttonState {
        case .on:
            configuration?.baseBackgroundColor = .mainGreen
            configuration?.baseForegroundColor = .white
            isEnabled = true
        case .off:
            configuration?.baseBackgroundColor = .actionButtonBackgroundOff
            configuration?.baseForegroundColor = .actionButtonTextOff
            isEnabled = false
        }
        self.configuration = configuration
    }
}

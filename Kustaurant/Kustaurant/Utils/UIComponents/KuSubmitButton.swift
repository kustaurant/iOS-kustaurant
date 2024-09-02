//
//  KuSubmitButton.swift
//  Kustaurant
//
//  Created by 송우진 on 8/1/24.
//

import UIKit

final class KuSubmitButton: UIButton {
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
        fatalError("init(coder:) has not been implemented")
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
            [.font: UIFont.Pretendard.semiBold18]
        ))
        let isOn = buttonState == .on
        configuration?.baseBackgroundColor = isOn ? .mainGreen : .actionButtonBackgroundOff
        configuration?.baseForegroundColor = isOn ? .white : .actionButtonTextOff
        isEnabled = isOn
        self.configuration = configuration
    }
}

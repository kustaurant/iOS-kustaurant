//
//  KuSubmitButton.swift
//  Kustaurant
//
//  Created by 송우진 on 8/1/24.
//

import UIKit

final class KuSubmitButton: UIButton {
    
    enum Size {
        case large, medium
        
        var font: UIFont {
            switch self {
            case .large:
                return .Pretendard.semiBold18
            case .medium:
                return .Pretendard.semiBold16
            }
        }
        
        var imagePadding: CGFloat {
            switch self {
            case .large:
                return 16
            case .medium:
                return 8
            }
        }
    }
    
    enum ButtonState {
        case on, off
        
        var backgroundColor: UIColor? {
            switch self {
            case .on:
                return .Signature.green100
            case .off:
                return .Sementic.gray75
            }
        }
        
        var foregroundColor: UIColor? {
            switch self {
            case .on:
                return .white
            case .off:
                return .Sementic.gray300
            }
        }
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
    
    var size: Size = .large {
        didSet {
            updateStyle()
        }
    }
    
    var image: UIImage? {
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
}

extension KuSubmitButton {
    
    private func setup() {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        self.configuration = configuration
        updateStyle()
    }
    
    private func updateStyle() {
        updateState()
        updateTitle()
        updateImage()
        updateColors()
    }
    
    private func updateTitle() {
        self.configuration?.title = buttonTitle
        self.configuration?.attributedTitle = AttributedString(
            buttonTitle,
            attributes: AttributeContainer(
                [.font: size.font]
            )
        )
    }
    
    private func updateState() {
        let isOn = buttonState == .on
        isEnabled = isOn
    }
    
    private func updateImage() {
        self.configuration?.image = image
        self.configuration?.imagePadding = size.imagePadding
        self.configuration?.imagePlacement = .leading
    }
    
    private func updateColors() {
        self.configuration?.baseBackgroundColor = buttonState.backgroundColor
        self.configuration?.baseForegroundColor = buttonState.foregroundColor
    }
}

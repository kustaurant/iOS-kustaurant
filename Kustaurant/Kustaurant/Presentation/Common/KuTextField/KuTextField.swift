//
//  KuTextField.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit

class KuTextField: UIView {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.semiBold16
        label.textColor = .black
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.Sementic.gray300?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 13
        textField.backgroundColor = .white
        return textField
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .Pretendard.medium12
        label.textColor = .Sementic.gray300
        return label
    }()
    
    var bottomLabelText: String = "" {
        didSet {
            bottomLabel.text = bottomLabelText
        }
    }
    
    var textFieldEnabled: Bool = true {
        didSet {
            setTextFieldEnabled(textFieldEnabled)
        }
    }
    
    var errorText: String? {
        didSet {
            updateErrorText()
        }
    }
    
    init(topLabelText: String, placeholder: String) {
        super.init(frame: .zero)
        setupUI()
        configure(topLabelText: topLabelText, placeholder: placeholder)
        textField.addLeftPadding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KuTextField {
    
    private func setupUI() {
        addSubview(topLabel, autoLayout: [.top(0), .leading(0), .trailing(0)])
        addSubview(textField, autoLayout: [.topNext(to: topLabel, constant: 7), .leading(0), .trailing(0), .height(44)])
        addSubview(bottomLabel, autoLayout: [.topNext(to: textField, constant: 8), .leading(0), .trailing(0), .bottom(0)])
    }
    
    private func configure(topLabelText: String, placeholder: String) {
        topLabel.text = topLabelText
        let placeholderFont = UIFont.Pretendard.regular14
        let placeholderColor = UIColor.Sementic.gray600 ?? .gray
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: placeholderColor,
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: attributes)
    }
    
    private func setTextFieldEnabled(_ isEnabled: Bool) {
        textField.isEnabled = isEnabled
        textField.backgroundColor = isEnabled ? .white : .Sementic.gray75
    }
    
    private func updateErrorText() {
        if let errorText = errorText, !errorText.isEmpty {
            bottomLabel.text = errorText
            bottomLabel.textColor = .red
        } else {
            bottomLabel.textColor = .Sementic.gray300
            bottomLabel.text = bottomLabelText
        }
    }
}

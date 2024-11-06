//
//  CommunityPostWriteRootView.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import UIKit

final class CommunityPostWriteRootView: UIView {
    private let topBorder: UIView = .init()
    private(set) var selectBoardButton: UIButton = .init()
    private let titleTextField: UITextField = .init()
    private let contentTextViewPlaceholderText = "내용을 입력해주세요.\n커뮤니티 이용 규칙에 의해 부적절한 게시물을 숨김, 삭제 처리될 수 있습니다."
    private let contentTextView: UITextView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
        setupKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommunityPostWriteRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
        topBorder.backgroundColor = .gray100
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13)
        configuration.imagePadding = 5
        configuration.image = UIImage(named: "icon_polygon")
        configuration.imagePlacement = .trailing
        configuration.attributedTitle = AttributedString(
            "게시판 선택",
            attributes: AttributeContainer([
                .font: UIFont.Pretendard.regular14,
                .foregroundColor: UIColor.mainGreen
            ])
        )
        selectBoardButton.configuration = configuration
        selectBoardButton.layer.borderWidth = 1.0
        selectBoardButton.layer.borderColor = UIColor.mainGreen.cgColor
        selectBoardButton.layer.cornerRadius = 29/2
        configureTitleTextField(titleTextField)
        configureContentTextView(contentTextView)
    }
    
    private func configureTitleTextField(_ field: UITextField) {
        field.delegate = self
        let placeholderFont: UIFont = .Pretendard.bold17
        let placeholderColor: UIColor = .gray300
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: placeholderColor,
        ]
        field.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: attributes)
        field.backgroundColor = .clear
        field.font = .Pretendard.semiBold17
        field.textColor = .textBlack
        field.returnKeyType = .next
    }
    
    private func configureContentTextView(_ textView: UITextView) {
        textView.delegate = self
        textView.font = .Pretendard.regular13
        textView.textColor = .gray300
        textView.backgroundColor = .clear
        textView.text = contentTextViewPlaceholderText
        textView.textContainerInset = UIEdgeInsets.zero
    }
    
    private func setupLayout() {
        addSubview(topBorder, autoLayout: [.topSafeArea(constant: 0), .fillX(0), .height(1.5)])
        addSubview(selectBoardButton, autoLayout: [.topSafeArea(constant: 20), .leading(20), .height(29)])
        addSubview(titleTextField, autoLayout: [.topNext(to: selectBoardButton, constant: 40), .fillX(20), .height(24)])
        let line = UIView()
        line.backgroundColor = .gray300
        addSubview(line, autoLayout: [.topNext(to: titleTextField, constant: 7), .fillX(20), .height(0.5)])
        addSubview(contentTextView, autoLayout: [.topNext(to: line, constant: 25), .fillX(20), .bottom(0)])
    }
}

// Keyboard
extension CommunityPostWriteRootView {
    private func setupKeyboard() {
        setupDismissKeyboardGesture()
        addInputAccessory()
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func addInputAccessory() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let imageButton = UIBarButtonItem(
            title: nil,
            image: UIImage(named: "icon_album")?.withRenderingMode(.alwaysOriginal),
            target: self,
            action: #selector(showPicker)
        )
        toolbar.setItems([imageButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        contentTextView.inputAccessoryView = toolbar
    }
    
    @objc private func showPicker() {
        
    }
}

// MARK: - UITextFieldDelegate
extension CommunityPostWriteRootView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension CommunityPostWriteRootView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentTextViewPlaceholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = contentTextViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
}

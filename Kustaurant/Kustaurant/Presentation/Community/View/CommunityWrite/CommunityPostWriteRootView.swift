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
    private(set) var titleTextField: UITextField = .init()
    private(set) var contentTextView: UITextView = .init()
    private let imageView: UIImageView = .init()
    private let contentTextViewPlaceholderText = "내용을 입력해주세요.\n커뮤니티 이용 규칙에 의해 부적절한 게시물을 숨김, 삭제 처리될 수 있습니다."
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupLayout()
        setupKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectBoardButtonTitle(_ title: String) {
        selectBoardButton.configuration?.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: UIFont.Pretendard.regular14,
                .foregroundColor: UIColor.mainGreen
            ])
        )
    }
    
    func updateContentTextView(_ text: String) {
        if text == contentTextViewPlaceholderText {
            contentTextView.text = nil
            contentTextView.textColor = .black
        }
        if text.isEmpty {
            contentTextView.text = contentTextViewPlaceholderText
            contentTextView.textColor = .lightGray
        }
    }
    
    func updateImageView(_ image: UIImage?) {
        imageView.image = image
    }
}

extension CommunityPostWriteRootView {
    private func setupStyle() {
        backgroundColor = .systemBackground
        topBorder.backgroundColor = .gray100
        configureSelectBoardButton()
        configureTitleTextField()
        configureContentTextView()
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleToFill
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPicker))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    private func configureSelectBoardButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13)
        configuration.imagePadding = 5
        configuration.image = UIImage(named: "icon_polygon")
        configuration.imagePlacement = .trailing
        selectBoardButton.configuration = configuration
        selectBoardButton.layer.borderWidth = 1.0
        selectBoardButton.layer.borderColor = UIColor.mainGreen.cgColor
        selectBoardButton.layer.cornerRadius = 29/2
        updateSelectBoardButtonTitle("게시판 선택")
    }
    
    private func configureTitleTextField() {
        let placeholderFont: UIFont = .Pretendard.bold17
        let placeholderColor: UIColor = .gray300
        let attributes: [NSAttributedString.Key: Any] = [
            .font: placeholderFont,
            .foregroundColor: placeholderColor,
        ]
        titleTextField.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: attributes)
        titleTextField.backgroundColor = .clear
        titleTextField.font = .Pretendard.semiBold17
        titleTextField.textColor = .textBlack
        titleTextField.returnKeyType = .next
    }
    
    private func configureContentTextView() {
        contentTextView.font = .Pretendard.regular13
        contentTextView.textColor = .gray300
        contentTextView.backgroundColor = .clear
        contentTextView.text = contentTextViewPlaceholderText
        contentTextView.textContainerInset = UIEdgeInsets.zero
    }
    
    private func setupLayout() {
        addSubview(topBorder, autoLayout: [.topSafeArea(constant: 0), .fillX(0), .height(1.5)])
        addSubview(selectBoardButton, autoLayout: [.topSafeArea(constant: 20), .leading(20), .height(29)])
        
        let imageViewSize: CGFloat = 60
        addSubview(imageView, autoLayout: [.topSafeArea(constant: 20), .trailing(10), .width(imageViewSize), .height(imageViewSize)])
        addSubview(titleTextField, autoLayout: [.topNext(to: selectBoardButton, constant: 40), .fillX(20), .height(24)])
        let line = UIView()
        line.backgroundColor = .gray300
        addSubview(line, autoLayout: [.topNext(to: titleTextField, constant: 7), .fillX(20), .height(0.5)])
        addSubview(contentTextView, autoLayout: [.topNext(to: line, constant: 25), .fillX(20), .bottomKeyboard(10)])
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
    
    @objc func dismissKeyboard() {
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
        guard let parentVC = parentViewController as? CommunityPostWriteViewController else { return }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = parentVC
        imagePickerController.sourceType = .photoLibrary
        parentVC.present(imagePickerController, animated: true)
    }
}

//
//  EvaluationReviewCell.swift
//  Kustaurant
//
//  Created by 송우진 on 9/27/24.
//

import UIKit

final class EvaluationReviewCell: UITableViewCell {
    private let kuImageView: UIImageView = .init()
    private let kuTextView: UITextView = .init()
    private let addImageButton: UIButton = .init()
    private let placeholderText = "(선택) 상세 평가를 10자 이상 입력해주세요"
    private let stackView: UIStackView = .init()
    private let imageSize = CGSize(width: 213, height: 207)
    
    var updateReview: ((String) -> Void)?
    var updateImage: ((Data?) -> Void)?
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupStyle()
        setupLayout()
        setupDismissKeyboardGesture()
        registerForKeyboardNotifications()
        addDoneButtonOnKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func update(data: EvaluationDTO?) {
        guard let data = data else { return }
        
        if let review = data.evaluationComment {
            kuTextView.text = review
            kuTextView.textColor = .black
        }
        
        loadImage(data.evaluationImgUrl)
    }
    
    private func loadImage(_ urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString)
        else { return }
        Task {
            let image = await ImageCacheManager.shared.loadImage(
                from: url,
                targetSize: imageSize
            )
            await MainActor.run {
                kuImageView.image = image
            }
        }
    }
}

extension EvaluationReviewCell {
    private func setupStyle() {
        selectionStyle = .none
        
        kuTextView.delegate = self
        kuTextView.font = .Pretendard.regular13
        kuTextView.textColor = .gray300
        kuTextView.layer.cornerRadius = 10
        kuTextView.backgroundColor = .gray75
        kuTextView.text = placeholderText
        kuTextView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        
        addImageButton.setTitle("+ 이미지 추가(선택)", for: .normal)
        addImageButton.setTitleColor(.reviewImageButtonText, for: .normal)
        addImageButton.layer.borderColor = UIColor.gray300.cgColor
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.cornerRadius = 13
        addImageButton.titleLabel?.font = .Pretendard.regular13
        addImageButton.addAction( UIAction { [weak self] _ in self?.openImagePicker() } , for: .touchUpInside)
        
        kuImageView.contentMode = .scaleAspectFill
        kuImageView.clipsToBounds = true
        kuImageView.layer.borderWidth = 1.0
        kuImageView.layer.borderColor = UIColor.gray50.cgColor
        kuImageView.backgroundColor = .gray100.withAlphaComponent(0.3)
        kuImageView.layer.cornerRadius = 10
    }
    
    private func setupLayout() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(kuImageView)
        stackView.addArrangedSubview(kuTextView)
        stackView.addArrangedSubview(addImageButton)

        let width = UIScreen.main.bounds.width - 40
        kuImageView.autolayout([.width(imageSize.width), .height(imageSize.height)])
        kuTextView.autolayout([.width(width),.height(160)])
        addImageButton.autolayout([.width(width), .height(46)])
        contentView.addSubview(stackView, autoLayout: [.top(0), .fillX(20), .bottom(100)])
    }
}


// MARK: - ImagePicker
extension EvaluationReviewCell {
    private func openImagePicker() {
        guard let parentVC = parentViewController else { return }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        parentVC.present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EvaluationReviewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            kuImageView.image = image
            updateImage?(image.jpegData(compressionQuality: 1.0))
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension EvaluationReviewCell {
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        kuTextView.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let parentVC = parentViewController else { return }
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let submitButtonHeight = EvaluationFloatingView.getHeight()
            let bottomInset = keyboardSize.height - submitButtonHeight
            parentVC.view.frame.origin.y = -bottomInset
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let parentVC = parentViewController else { return }
        parentVC.view.frame.origin.y = 0
    }
    
    private func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        kuTextView.inputAccessoryView = toolbar
    }
}

// MARK: - UITextViewDelegate
extension EvaluationReviewCell: UITextViewDelegate {
    // 텍스트뷰가 편집을 시작할 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 텍스트뷰 편집이 끝났을 때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = .lightGray
        } else {
            updateReview?(textView.text)
        }
    }
}

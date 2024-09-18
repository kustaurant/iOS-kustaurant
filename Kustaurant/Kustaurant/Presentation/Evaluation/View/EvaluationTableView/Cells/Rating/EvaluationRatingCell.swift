//
//  EvaluationRatingCell.swift
//  Kustaurant
//
//  Created by 송우진 on 9/11/24.
//

import UIKit

final class EvaluationRatingCell: UITableViewCell {
    private let containerView: UIView = .init()
    private let titleLabel: UILabel = .init()
    private let starRatingView: StarRatingView = StarRatingView()
    private let starCommentsLabel: UILabel = .init()
    private let reviewTextView: UITextView = .init()
//    private let addImageButton: UIButton = .init()
    private let reviewPlaceholderText = "(선택) 상세 평가를 10자 이상 입력해주세요"
    
    private var evaluationData: EvaluationDTO? = nil
    
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
        bindRating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EvaluationRatingCell {
    func update(data: EvaluationDTO?) {
        guard let data = data else { return }
        evaluationData = data
        
        if let score = data.evaluationScore {
            starRatingView.rating = Float(score)
        }
        
        updateComments(rating: starRatingView.rating)
    }
    
    private func updateComments(rating: Float) {
        let comments = evaluationData?.starComments?.compactMap({$0}).first(where: { $0.star == Double(rating) })?.comment ?? ""
        starCommentsLabel.text = comments
    }
    
    private func bindRating() {
        starRatingView.ratingChanged = { [weak self] rating in
            guard rating <= 5.0 else { return }
            self?.updateComments(rating: rating)
        }
    }
}

extension EvaluationRatingCell {
    
    private func setupStyle() {
        selectionStyle = .none
        
        titleLabel.text = "별점을 선택해 주세요"
        titleLabel.font = .Pretendard.medium18
        titleLabel.textColor = .textBlack
        
        starCommentsLabel.font = .Pretendard.medium15
        starCommentsLabel.textColor = .gray600
        
        reviewTextView.delegate = self
        reviewTextView.font = .Pretendard.regular13
        reviewTextView.textColor = .gray300
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.backgroundColor = .gray75
        reviewTextView.text = reviewPlaceholderText
        reviewTextView.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        
//        addImageButton.setTitle("+ 이미지 추가(선택)", for: .normal)
//        addImageButton.setTitleColor(.reviewImageButtonText, for: .normal)
//        addImageButton.layer.borderColor = UIColor.gray300.cgColor
//        addImageButton.layer.borderWidth = 1
//        addImageButton.layer.cornerRadius = 13
//        addImageButton.titleLabel?.font = .Pretendard.regular13
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView, autoLayout: [.fill(0)])
        containerView.addSubview(titleLabel, autoLayout: [.leading(20), .top(0), .height(42)])
        containerView.addSubview(starRatingView, autoLayout: [.topNext(to: titleLabel, constant: 6), .leading(20), .width(208), .height(40)])
        containerView.addSubview(starCommentsLabel, autoLayout: [.topNext(to: starRatingView, constant: 6), .fillX(20)])
        containerView.addSubview(reviewTextView, autoLayout: [.topNext(to: starCommentsLabel, constant: 24), .fillX(20), .height(160), .bottom(110)])
//        containerView.addSubview(addImageButton, autoLayout: [.topNext(to: reviewTextView, constant: 12), .fillX(20), .height(46), .bottom(90)])
    }
}

// MARK: - Keyboard
extension EvaluationRatingCell {
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        reviewTextView.resignFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func submitButtonHeight() -> CGFloat {
        let window = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow }
        let bottomSafeAreaHeight = window?.safeAreaInsets.bottom ?? 0
        return 68 + (bottomSafeAreaHeight == 0 ? 16 : bottomSafeAreaHeight)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let parentVC = parentViewController else { return }
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let bottomInset = keyboardSize.height - submitButtonHeight()
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
        
        reviewTextView.inputAccessoryView = toolbar
    }
}

// MARK: - UITextViewDelegate
extension EvaluationRatingCell: UITextViewDelegate {
    // 텍스트뷰가 편집을 시작할 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == reviewPlaceholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 텍스트뷰 편집이 끝났을 때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = reviewPlaceholderText
            textView.textColor = .lightGray
        }
    }
}
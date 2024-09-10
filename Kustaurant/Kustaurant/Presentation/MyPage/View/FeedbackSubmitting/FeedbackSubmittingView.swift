//
//  FeedbackSubmittingView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit

class FeedbackSubmittingView: UIView {
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Sementic.gray300
        label.font = .Pretendard.regular13
        label.text = "어떤 피드백이든 감사합니다!"
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .Sementic.gray75
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 0, right: 0)
        tv.layer.cornerRadius = 10
        tv.clipsToBounds = true
        return tv
    }()
    
    let textCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Sementic.gray300
        label.font = .Pretendard.regular13
        label.text = "0/300"
        return label
    }()
    
    let submitButton: KuSubmitButton = {
        let button = KuSubmitButton()
        button.buttonState = .off
        button.buttonTitle = "제출하기"
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FeedbackSubmittingView {
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(textView, autoLayout: [.topSafeArea(constant: 52), .fillX(20), .height(200)])
        textView.addSubview(placeHolderLabel, autoLayout: [.top(16), .leading(12)])
        addSubview(textCountLabel, autoLayout: [.topNext(to: textView, constant: 8), .trailingEqual(to: textView, constant: 8)])
        addSubview(submitButton, autoLayout: [.bottomSafeArea(constant: 20), .fillX(20), .height(52)])
    }
}

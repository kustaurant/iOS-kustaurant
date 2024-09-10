//
//  FeedbackSubmittingViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import UIKit
import Combine

class FeedbackSubmittingViewController: UIViewController {
    
    private let feedbackSubmittingView = FeedbackSubmittingView()
    private let viewModel: FeedbackSubmittingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: FeedbackSubmittingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTextView()
        setupKeyboardEndGesture()
        bind()
    }
    
    override func loadView() {
        view = feedbackSubmittingView
    }
}

extension FeedbackSubmittingViewController {
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "icon_back")
        let backButtonView = UIImageView(image: backImage)
        let backButton = UIBarButtonItem(customView: backButtonView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButtonView.addGestureRecognizer(tapGesture)
        backButtonView.isUserInteractionEnabled = true
        navigationItem.title = "피드백 보내기"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        viewModel.didTapBackButton()
    }
    
    private func setupTextView() {
        feedbackSubmittingView.textView.delegate = self
    }
    
    private func setupKeyboardEndGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        feedbackSubmittingView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        feedbackSubmittingView.endEditing(true)
    }
    
    private func bind() {
        viewModel.textViewFocusedPublisher
            .combineLatest(viewModel.feedbackTextPublisher)
            .sink { [weak self] focused, text in
                self?.feedbackSubmittingView.placeHolderLabel.isHidden = focused || text != ""
            }
            .store(in: &cancellables)
        
        viewModel.feedbackTextPublisher.sink { [weak self] text in
            self?.feedbackSubmittingView.textCountLabel.text = "\(text.count)/\(self?.viewModel.maxTextCount ?? 300)"
            self?.feedbackSubmittingView.submitButton.buttonState = text.count > 0 ? .on : .off
        }
        .store(in: &cancellables)
        
        viewModel.showAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showAlert in
            if showAlert {
                self?.presentAlert()
            }
        }
        .store(in: &cancellables)
        
        feedbackSubmittingView.submitButton.tapPublisher().sink { [weak self] in
            self?.viewModel.didTapSubmitButton()
        }
        .store(in: &cancellables)
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: "피드백이 접수되었습니다.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.feedbackSubmittingView.textView.text = ""
            self?.viewModel.didTapOkInAlert()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension FeedbackSubmittingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel.textViewFocused(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        viewModel.textViewFocused(false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.updateFeedbackText(textView.text)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= viewModel.maxTextCount
    }
}

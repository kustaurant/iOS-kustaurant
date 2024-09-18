//
//  RestaurantDetailCommentTextFieldHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/5/24.
//

import UIKit
import Combine

struct CommentPayload {
    let commentId: Int?
    let comment: String?
}

final class RestaurantDetailAccessoryViewHandler: NSObject {
    
    private let viewController: RestaurantDetailViewController
    private let accessoryView: CommentAccessoryView
    private let viewModel: RestaurantDetailViewModel
    
    private var text = ""
    private var commentId: Int?
    
    init(
        viewController: RestaurantDetailViewController,
        accessoryView: CommentAccessoryView,
        viewModel: RestaurantDetailViewModel
    ) {
        self.viewController = viewController
        self.accessoryView = accessoryView
        self.viewModel = viewModel
    }
}

extension RestaurantDetailAccessoryViewHandler: UIGestureRecognizerDelegate {

    func setupAccessoryView() {
        accessoryView.textField.delegate = self
        hideKeyboard()
        setupKeyboardEndGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: accessoryView.textField)
    }

    func showKeyboard(commentId: Int) {
        self.commentId = commentId
        accessoryView.isHidden = false
        accessoryView.textField.becomeFirstResponder()
    }

    @objc func hideKeyboard() {
        commentId = nil
        text = ""
        accessoryView.isHidden = true
        accessoryView.textField.text = ""
        accessoryView.textField.resignFirstResponder()
    }

    private func setupKeyboardEndGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        viewController.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            text = textField.text ?? ""
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isDescendant(of: accessoryView.sendButton) {
            return false
        }
        return true
    }

    func sendButtonTapPublisher() -> AnyPublisher<CommentPayload, Never> {
        return accessoryView.sendButtonTapPublisher().map { [weak self] in
            CommentPayload(commentId: self?.commentId, comment: self?.text)
        }.eraseToAnyPublisher()
    }
    
    func unregisterAccessoryView() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: accessoryView.textField)
    }
}

extension RestaurantDetailAccessoryViewHandler: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text as NSString? {
            let newText = currentText.replacingCharacters(in: range, with: string)
            text = newText
        }
        
        return true
    }
}

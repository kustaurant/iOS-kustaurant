//
//  CommunityPostDetailAccessoryHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 11/21/24.
//

import UIKit

final class CommunityPostDetailAccessoryHandler: NSObject {
    private let viewController: UIViewController
    private let accessoryView: CommentAccessoryView
    private let viewModel: CommunityPostDetailViewModel
    var payload: DefaultCommunityPostDetailViewModel.CommentPayload?
    
    init(
        viewController: UIViewController,
        accessoryView: CommentAccessoryView,
        viewModel: CommunityPostDetailViewModel
    ) {
        self.viewController = viewController
        self.accessoryView = accessoryView
        self.viewModel = viewModel
        super.init()
        setupAccessoryView()
    }
    
    func showKeyboard(_ payload: DefaultCommunityPostDetailViewModel.CommentPayload) {
        self.payload = payload
        accessoryView.isHidden = false
        accessoryView.textField.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        payload = nil
        accessoryView.isHidden = true
        accessoryView.textField.text?.removeAll()
        accessoryView.textField.resignFirstResponder()
    }
}

extension CommunityPostDetailAccessoryHandler {
    private func setupAccessoryView() {
        hideKeyboard()
        accessoryView.sendButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.process(.tapSendButtonInAccessory(payload: self?.payload))
                self?.hideKeyboard()
            }
            , for: .touchUpInside)
    }
}

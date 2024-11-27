//
//  CommunityPostWriteViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import UIKit
import Combine

protocol CommunityPostWriteDelegate: AnyObject {
    func didCreatePost()
}

final class CommunityPostWriteViewController: NavigationBarLeftBackButtonViewController, LoadingDisplayable {
    weak var delegate: CommunityPostWriteDelegate?
    private var viewModel: CommunityPostWriteViewModel
    private var rootView = CommunityPostWriteRootView()
    private let doneButton: KuSubmitButton = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CommunityPostWriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelAction()
        bindRootView()
        setupMenu()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        doneButton.buttonTitle = "완료"
        doneButton.size = .custom(.Pretendard.regular14, 0)
        let doneButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addAction(UIAction { [weak self] _ in
            self?.submit()
        }, for: .touchUpInside)
        navigationItem.rightBarButtonItem = doneButtonItem
        navigationItem.title = "게시글 작성"
    }
}

extension CommunityPostWriteViewController {
    private func bindViewModelAction() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .showLoading(let isLoading):
                    if isLoading {
                        self?.showLoadingView()
                    } else {
                        self?.hideLoadingView()
                    }
                case .updateCategory(let category):
                    self?.rootView.updateSelectBoardButtonTitle(category.rawValue)
                case .changeStateDoneButton(let isComplete):
                    self?.doneButton.buttonState = isComplete ? .on : .off
                case .didCreatePost:
                    self?.delegate?.didCreatePost()
                case .showAlert(payload: let payload):
                    self?.presentAlert(payload: payload)
                }
            }.store(in: &cancellables)
    }
    
    private func bindRootView() {
        rootView.titleTextField.delegate = self
        rootView.contentTextView.delegate = self
    }
}

extension CommunityPostWriteViewController {
    
    private func setupMenu() {
        var actions: [UIAction] = []
        CommunityPostCategory.allCases.forEach { category in
            guard category != .all else { return }
            let action = UIAction(title: category.rawValue) { [weak self] _ in
                self?.viewModel.process(.changeCategory(category))
            }
            actions.append(action)
        }
        let menu = UIMenu(title: "게시판 선택", children: actions)
        rootView.selectBoardButton.menu = menu
        rootView.selectBoardButton.showsMenuAsPrimaryAction = true
    }
    
    private func presentAlert(payload: AlertPayload) {
        let alert = UIAlertController(title: payload.title, message: payload.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            payload.onConfirm?()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func submit() {
        viewModel.process(.updateTitle(rootView.titleTextField.text ?? ""))
        rootView.dismissKeyboard()
        viewModel.process(.tappedDoneButton)
    }
}

// MARK: - UITextFieldDelegate
extension CommunityPostWriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rootView.contentTextView.becomeFirstResponder()
        return true
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let title = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        viewModel.process(.updateTitle(title))
        return true
    }
}

// MARK: - UITextViewDelegate
extension CommunityPostWriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        rootView.updateContentTextView(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        rootView.updateContentTextView(textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let content = textView.text else { return }
        viewModel.process(.updateContent(content))
    }
}


// MARK: ImagePicker
extension CommunityPostWriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[.originalImage] as? UIImage
        rootView.updateImageView(image)
        let imageData = image?.jpegData(compressionQuality: 1.0)
        viewModel.process(.updateImageData(imageData))
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

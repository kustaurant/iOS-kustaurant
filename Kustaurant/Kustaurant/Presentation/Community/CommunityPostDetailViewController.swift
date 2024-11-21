//
//  CommunityPostDetailViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 10/27/24.
//

import UIKit
import Combine

protocol CommunityPostDetailDelegate: AnyObject {
    func didDeletePost(postId: Int)
}

final class CommunityPostDetailViewController: NavigationBarLeftBackButtonViewController, LoadingDisplayable {
    weak var delegate: CommunityPostDetailDelegate?
    private var rootView = CommunityPostDetailRootView()
    private var viewModel: CommunityPostDetailViewModel
    private var detailTableViewHandler: CommunityPostDetailTableViewHandler?
    private var accessoryViewHandler: CommunityPostDetailAccessoryHandler?
    private let menuEllipsisButton: UIButton = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: CommunityPostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        detailTableViewHandler = CommunityPostDetailTableViewHandler(
            tableView: rootView.tableView,
            viewModel: viewModel
        )
        accessoryViewHandler = CommunityPostDetailAccessoryHandler(
            viewController: self,
            accessoryView: rootView.commentAccessoryView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        accessoryViewHandler?.unregisterAccessoryView()
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModelAction()
        detailTableViewHandler?.update()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        menuEllipsisButton.setImage(UIImage(named: "icon_ellipsis_black"), for: .normal)
        menuEllipsisButton.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        let rightBarButtonItem = UIBarButtonItem(customView: menuEllipsisButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = viewModel.post.postCategory ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.process(.fetchPostDetail)
    }
}


extension CommunityPostDetailViewController {
    private func bindViewModelAction() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .showLoading(let isLoading, let isBlocking):
                    if isLoading {
                        self?.showLoadingView(isBlocking: isBlocking)
                    } else {
                        self?.hideLoadingView()
                    }
                case .touchLikeButton:
                    self?.detailTableViewHandler?.update()
                case .didFetchPostDetail:
                    self?.didFetchPostDetail()
                case .touchScrapButton:
                    self?.detailTableViewHandler?.update()
                case .updateCommentActionButton:
                    self?.detailTableViewHandler?.update()
                case .deleteComment:
                    self?.detailTableViewHandler?.update()
                case .showAlert(payload: let payload):
                    self?.presentAlert(payload: payload)
                case .deletePost:
                    self?.deletePost()
                case .showKeyboard(let comment):
                    self?.accessoryViewHandler?.showKeyboard(comment)
                }
            }
            .store(in: &cancellables)
    }
    
    private func deletePost() {
        delegate?.didDeletePost(postId: viewModel.post.postId ?? 0)
        navigationController?.popViewController(animated: true)
    }
    
    private func didFetchPostDetail() {
        setupMenu()
        detailTableViewHandler?.update()
    }
    
    private func setupMenu() {
        let deleteAction = UIAction(title: "삭제하기", image: UIImage(named: "icon_trash"), attributes: .destructive) { [weak self] _ in
            self?.viewModel.process(.touchDeleteMenu)
        }
        let writeCommentAction = UIAction(title: "댓글작성") { [weak self] _ in
            self?.viewModel.process(.touchWriteCommentMenu)
        }
        var childrenActions: [UIMenuElement] = [writeCommentAction]
        if viewModel.post.isPostMine ?? false {
            childrenActions.insert(deleteAction, at: 0)
        }
        let menu = UIMenu(title: "", children: childrenActions)
        menuEllipsisButton.menu = menu
        menuEllipsisButton.showsMenuAsPrimaryAction = true
    }
    
    private func presentAlert(payload: AlertPayload) {
        let alert = UIAlertController(title: payload.title, message: payload.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            payload.onConfirm?()
        }))
        present(alert, animated: true, completion: nil)
    }
}

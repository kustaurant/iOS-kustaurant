//
//  CommunityPostDetailViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 10/27/24.
//

import UIKit
import Combine

final class CommunityPostDetailViewController: UIViewController, LoadingDisplayable {
    private var rootView = CommunityPostDetailRootView()
    private var viewModel: CommunityPostDetailViewModel
    private var detailTableViewHandler: CommunityPostDetailTableViewHandler?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: CommunityPostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        detailTableViewHandler = CommunityPostDetailTableViewHandler(
            tableView: rootView.tableView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bindViewModelAction()
        detailTableViewHandler?.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.process(.fetchPostDetail)
    }
}

extension CommunityPostDetailViewController {
    private func setupNavigationBar() {
        title = viewModel.post.postCategory ?? ""
    }
    
    private func bindViewModelAction() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .showLoading(let isLoading):
                    if isLoading {
                        self?.showLoadingView(isBlocking: false)
                    } else {
                        self?.hideLoadingView()
                    }
                case .touchLikeButton:
                    self?.detailTableViewHandler?.update()
                case .didFetchPostDetail:
                    self?.detailTableViewHandler?.update()
                case .touchScrapButton:
                    self?.detailTableViewHandler?.update()
                case .updateCommentActionButton:
                    self?.detailTableViewHandler?.update()
                case .deleteComment:
                    self?.detailTableViewHandler?.update()
                }
            }
            .store(in: &cancellables)
    }
}

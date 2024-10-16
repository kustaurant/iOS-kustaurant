//
//  CommunityViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit
import Combine

final class CommunityViewController: UIViewController, LoadingDisplayable {
    private var rootView = CommunityRootView()
    private let viewModel: CommunityViewModel
    private var postsCollectionViewHandler: CommunityPostsCollectionViewHandler?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        postsCollectionViewHandler = CommunityPostsCollectionViewHandler(
            collectionView: rootView.postsCollectionView,
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
        viewModel.process(.updateCategory(.all))
    }
}

extension CommunityViewController {
    private func setupNavigationBar() {
        title = "커뮤니티"
    }
}

extension CommunityViewController {
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
                case .didFetchPosts:
                    self?.postsCollectionViewHandler?.update()
                case .changeCategory(let category):
                    self?.rootView.updateFilterView(category: category)
                case .changeSortType(let sortType):
                    self?.rootView.updateFilterView(sortType: sortType)
                }
            }
            .store(in: &cancellables)
    }
}

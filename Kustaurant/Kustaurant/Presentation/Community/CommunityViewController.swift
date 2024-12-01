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
        bindButtons()
        viewModel.process(.updateCategory(nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.process(.checkNewPost)
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
                        self?.showLoadingView(isBlocking: false)
                    } else {
                        self?.hideLoadingView()
                    }
                case .didFetchPosts:
                    self?.postsCollectionViewHandler?.update()
                case .changeCategory(let category):
                    self?.rootView.updateFilterView(category: category)
                case .changeSortType(let sortType):
                    self?.rootView.updateFilterView(sortType: sortType)
                case .presentActionSheet:
                    self?.presentActionSheet()
                case .scrollToTop(let isAnimated):
                    self?.postsCollectionViewHandler?.scrollToTop(animated: isAnimated)
                case .reloadPosts:
                    self?.postsCollectionViewHandler?.update()
                case .endRefreshing:
                    self?.postsCollectionViewHandler?.endRefreshing()
                }
            }
            .store(in: &cancellables)
    }
    
    private func bindButtons() {
        rootView.communityFilterView.boardButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.process(.tappedBoardButton)
            }, for: .touchUpInside)
        rootView.communityFilterView.recentButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.process(.tappedSortTypeButton(.recent))
            }, for: .touchUpInside)
        rootView.communityFilterView.popularButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.process(.tappedSortTypeButton(.popular))
            }, for: .touchUpInside)
        rootView.writeButton.addAction(
            UIAction { [weak self] _ in
                self?.viewModel.process(.tappedWriteButton)
            }
            , for: .touchUpInside)
    }
    
    private func presentActionSheet() {
        let actionSheet = UIAlertController(title: "게시판 선택", message: nil, preferredStyle: .actionSheet)
        CommunityPostCategory.allCases.forEach { [weak self] category in
            let action = UIAlertAction(title: category.rawValue, style: .default) { [weak self] _ in
                self?.viewModel.process(.updateCategory(category))
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension CommunityViewController: CommunityPostWriteDelegate {
    func didCreatePost() {
        viewModel.process(.newCreatePost)
    }
}

extension CommunityViewController: CommunityPostDetailDelegate {
    func didDeletePost(postId: Int) {
        viewModel.process(.deletePost(postId))
    }
}

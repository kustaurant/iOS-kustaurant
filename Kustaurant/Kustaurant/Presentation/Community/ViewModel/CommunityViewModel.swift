//
//  CommunityViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation
import Combine

struct CommunityViewModelActions {
    let showPostDetail: (CommunityPostDTO) -> Void
    let showPostWrite: () -> Void
}

protocol CommunityViewModelInput {
    func process(_ state: DefaultCommunityViewModel.State)
}

protocol CommunityViewModelOutput {
    var actionPublisher: AnyPublisher<DefaultCommunityViewModel.Action, Never> { get }
    var posts: [CommunityPostDTO] { get }
}

typealias CommunityViewModel = CommunityViewModelInput & CommunityViewModelOutput

extension DefaultCommunityViewModel {
    enum State {
        case initial, fetchPostsNextPage, updateCategory(CommunityPostCategory?), updateSortType(CommunityPostSortType), tappedBoardButton, tappedSortTypeButton(CommunityPostSortType), didSelectPostCell(CommunityPostDTO), tappedWriteButton, newCreatePost, checkNewPost, deletePost(Int)
    }
    enum Action {
        case showLoading(Bool), didFetchPosts, changeCategory(CommunityPostCategory), changeSortType(CommunityPostSortType), presentActionSheet, scrollToTop(Bool), reloadPosts
    }
}

final class DefaultCommunityViewModel: CommunityViewModel {
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<DefaultCommunityViewModel.Action, Never> = .init()
    var actionPublisher: AnyPublisher<DefaultCommunityViewModel.Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var posts: [CommunityPostDTO] = []
    
    private var isNewCreatePost = false
    private var isLastPage = false
    private var currentPage = 0
    private var currentCategory: CommunityPostCategory = .all
    private var currentSortType: CommunityPostSortType = .recent
    private var isFetching = false {
        didSet {
            Task { @MainActor in
                actionSubject.send(.showLoading(isFetching))
            }
        }
    }
    
    private let communityUseCase: CommunityUseCases
    private let actions: CommunityViewModelActions
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization
    init(
        communityUseCase: CommunityUseCases,
        actions: CommunityViewModelActions
    ) {
        self.communityUseCase = communityUseCase
        self.actions = actions
        bindState()
    }
}

extension DefaultCommunityViewModel {
    func process(_ state: DefaultCommunityViewModel.State) {
        self.state = state
    }
    
    private func bindState() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                case .fetchPostsNextPage:
                    self?.fetchPostsNextPage()
                case .updateCategory(let category):
                    self?.updateCategory(category)
                case .updateSortType(let sortType):
                    self?.updateSortType(sortType)
                case .tappedBoardButton:
                    self?.tappedBoardButton()
                case .tappedSortTypeButton(let sortType):
                    self?.tappedSortTypeButton(sortType)
                case .didSelectPostCell(let post):
                    self?.actions.showPostDetail(post)
                case .tappedWriteButton:
                    self?.actions.showPostWrite()
                case .newCreatePost:
                    self?.isNewCreatePost = true
                case .checkNewPost:
                    self?.checkNewPost()
                case .deletePost(let postId):
                    self?.deletePost(postId)
                }
            }
            .store(in: &cancellables)
    }
}

extension DefaultCommunityViewModel {
    private func handleError(_ error: Error) {
        let errorLocalizedDescription: String
        switch error {
        case let networkError as NetworkError:
            errorLocalizedDescription = networkError.localizedDescription
        default:
            errorLocalizedDescription = error.localizedDescription
        }
        Logger.error("Error in {\(#fileID)} : \(errorLocalizedDescription)")
    }
    
    private func deletePost(_ postId: Int) {
        guard let postIndex = posts.firstIndex(where: { $0.postId == postId }) else { return }
        posts.remove(at: postIndex)
        actionSubject.send(.reloadPosts)
    }
    
    private func checkNewPost() {
        guard isNewCreatePost else { return }
        isNewCreatePost = false
        Task {
            initialisePosts()
            await self.fetchPosts()
            actionSubject.send(.scrollToTop(false))
        }
    }

    private func tappedSortTypeButton(_ sortType: CommunityPostSortType) {
        guard !isFetching else { return }
        updateSortType(sortType)
    }
    
    private func tappedBoardButton() {
        guard !isFetching else { return }
        actionSubject.send(.presentActionSheet)
    }
    
    private func updateSortType(_ sortType: CommunityPostSortType) {
        Task {
            currentSortType = sortType
            initialisePosts()
            actionSubject.send(.changeSortType(sortType))
            
            await fetchPosts()
            actionSubject.send(.scrollToTop(true))
        }
    }
    
    private func updateCategory(_ category: CommunityPostCategory?) {
        Task {
            currentCategory = category ?? .all
            initialisePosts()
            actionSubject.send(.changeCategory(currentCategory))
            
            await fetchPosts()
            actionSubject.send(.scrollToTop(true))
        }
    }
    
    private func initialisePosts() {
        currentPage = 0
        isLastPage = false
        if !posts.isEmpty {
            posts.removeAll()
        }
    }
    
    private func fetchPostsNextPage() {
        guard !isFetching && !isLastPage else { return }
        Task {
            await fetchPosts()
        }
    }
    
    private func fetchPosts() async {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }
        let result = await communityUseCase.fetchPosts(category: currentCategory, page: currentPage, sort: currentSortType)
        switch result {
        case .success(let success):
            guard !success.isEmpty else {
                isLastPage = true
                return
            }
            currentPage += 1
            posts += success
            actionSubject.send(.didFetchPosts)
        case .failure(let failure):
            handleError(failure)
        }
    }
}

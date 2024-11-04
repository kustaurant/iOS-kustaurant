//
//  CommunityPostDetailViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Combine
import Foundation

protocol CommunityPostDetailViewModelInput {
    func process(_ state: DefaultCommunityPostDetailViewModel.State)
}
protocol CommunityPostDetailViewModelOutput {
    var detail: CommunityPostDetail {get}
    var post: CommunityPostDTO {get}
    var actionPublisher: AnyPublisher<DefaultCommunityPostDetailViewModel.Action, Never> { get }
}

typealias CommunityPostDetailViewModel = CommunityPostDetailViewModelInput & CommunityPostDetailViewModelOutput

extension DefaultCommunityPostDetailViewModel {
    enum State {
        case initial, fetchPostDetail, touchLikeButton, touchScrapButton, touchCommentLikeButton(Int?), touchCommentDislikeButton(Int?), touchEllipsisDelete(Int?)
    }
    
    enum Action {
        case showLoading(Bool), didFetchPostDetail, touchLikeButton, touchScrapButton, updateCommentActionButton, deleteComment
    }
}

final class DefaultCommunityPostDetailViewModel: CommunityPostDetailViewModel {
    // Output
    let post: CommunityPostDTO
    var detail: CommunityPostDetail
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    @Published private var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var postId: Int { post.postId ?? 0 }
    private var isFetchingData: Bool = false
    private let communityUseCase: CommunityUseCases
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization
    init(
        post: CommunityPostDTO,
        communityUseCase: CommunityUseCases
    ) {
        self.communityUseCase = communityUseCase
        self.post = post
        self.detail = CommunityPostDetail(post: post)
        bindState()
    }
    
    // Input
    func process(_ state: State) {
        self.state = state
    }
}

extension DefaultCommunityPostDetailViewModel {
    private func bindState() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                case .fetchPostDetail:
                    self?.fetchPostDetail()
                case .touchLikeButton:
                    self?.updateLikeButton()
                case .touchScrapButton:
                    self?.updateScrapButton()
                case .touchCommentLikeButton(let commentId):
                    self?.updateCommentActions(commentId, action: .likes)
                case .touchCommentDislikeButton(let commentId):
                    self?.updateCommentActions(commentId, action: .dislikes)
                case .touchEllipsisDelete(let commentId):
                    self?.deleteComment(commentId)
                }
            }
            .store(in: &cancellables)
    }
}

extension DefaultCommunityPostDetailViewModel {
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
    
    private func deleteComment(_ commentId: Int?) {
        guard let commentId,
              !isFetchingData
        else { return }
        isFetchingData = true
        Task {
            defer { isFetchingData = false }
            let result = await communityUseCase.deleteComment(commentId: commentId)
            switch result {
            case .success(_):
                await detail.deleteComment(id: commentId)
                actionSubject.send(.deleteComment)
            case .failure(let failure):
                handleError(failure)
            }
        }
    }
    
    private func updateCommentActions(
        _ commentId: Int?,
        action: CommentActionType
    ) {
        guard let commentId,
              !isFetchingData
        else { return }
        isFetchingData = true
        Task {
            defer { isFetchingData = false }
            let result = await communityUseCase.commentActionToggle(commentId: commentId, action: action)
            switch result {
            case .success(let success):
                await detail.updateCommentStatus(id: commentId, status: success)
                actionSubject.send(.updateCommentActionButton)
            case .failure(let failure):
                handleError(failure)
            }
        }
    }
    
    private func fetchPostDetail() {
        Task {
            actionSubject.send(.showLoading(true))
            defer { actionSubject.send(.showLoading(false)) }
            let result = await communityUseCase.fetchPostDetail(postId: postId)
            switch result {
            case .success(let success):
                detail = CommunityPostDetail(post: success)
                actionSubject.send(.didFetchPostDetail)
            case .failure(let failure):
                handleError(failure)
            }
        }
    }
    
    private func updateScrapButton() {
        guard !isFetchingData else { return }
        isFetchingData = true
        Task {
            defer { isFetchingData = false }
            let result = await communityUseCase.postDetailScrapToggle(postId: postId)
            switch result {
            case .success(let scrapStatus):
                await detail.updateScrapButtonStatus(scrapStatus)
                actionSubject.send(.touchScrapButton)
            case .failure(let failure):
                handleError(failure)
            }
        }
    }
    
    private func updateLikeButton() {
        guard !isFetchingData else { return }
        isFetchingData = true
        Task {
            defer { isFetchingData = false }
            let result = await communityUseCase.postDetailLikeToggle(postId: postId)
            switch result {
            case .success(let likeStatus):
                await detail.updatelikeButtonStatus(likeStatus)
                actionSubject.send(.touchLikeButton)
            case .failure(let failure):
                handleError(failure)
            }
        }
    }
}

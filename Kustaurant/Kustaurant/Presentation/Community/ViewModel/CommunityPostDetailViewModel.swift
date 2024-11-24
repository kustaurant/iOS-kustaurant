//
//  CommunityPostDetailViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Combine
import Foundation

enum CommunityPostDetailError: Error, Equatable {
    case nullPostId
    case nullPostContent
    
    var localizedDescription: String {
        switch self {
        case .nullPostId:
            return "Null Post ID"
        case .nullPostContent:
            return "Null Post Content"
        }
    }
}

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
        case initial, fetchPostDetail, touchLikeButton, touchScrapButton, touchCommentLikeButton(Int?), touchCommentDislikeButton(Int?), touchEllipsisDelete(Int?), touchDeleteMenu, touchWriteCommentMenu, tapSendButtonInAccessory(payload: CommentPayload?)
    }
    
    enum Action {
        case showLoading(Bool, Bool), didFetchPostDetail, touchLikeButton, touchScrapButton, updateCommentActionButton, deleteComment, showAlert(payload: AlertPayload), deletePost, showKeyboard(CommentPayload), didWriteComment
    }
}

final class DefaultCommunityPostDetailViewModel: CommunityPostDetailViewModel {
    // Output
    var post: CommunityPostDTO
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
    
    struct CommentPayload {
        let id: Int?
        let type: DataType
        var content: String? = nil
        enum DataType {
            case post, comment
        }
    }
    
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
                case .touchDeleteMenu:
                    self?.actionSubject.send(.showAlert(
                        payload: AlertPayload(
                            title: "게시글 삭제",
                            subtitle: "정말 삭제하시겠어요?",
                            onConfirm: { [weak self]  in
                                self?.deletePost()
                            }))
                    )
                case .touchWriteCommentMenu:
                    self?.actionSubject.send(.showKeyboard(
                        CommentPayload(id: self?.postId, type: .post)
                    ))
                case .tapSendButtonInAccessory(payload: let payload):
                    self?.writeComment(payload: payload)
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
    
    private func writeComment(payload: CommentPayload?) {
        guard !isFetchingData else { return }
        isFetchingData = true
        Task {
            actionSubject.send(.showLoading(true, true))
            defer {
                actionSubject.send(.showLoading(false, true))
                isFetchingData = false
            }
            do {
                guard let postId = payload?.id else {
                    throw CommunityPostDetailError.nullPostId
                }
                guard let content = payload?.content else {
                    throw CommunityPostDetailError.nullPostContent
                }
                let result = await communityUseCase.writeComment(postId: postId, parentCommentId: nil, content: content)
                switch result {
                case .success(_):
                    actionSubject.send(.didWriteComment)
                case .failure(let failure):
                    throw failure
                }
            } catch {
                handleError(error)
            }
        }
    }
    
    private func deletePost() {
        guard !isFetchingData else { return }
        isFetchingData = true
        Task {
            actionSubject.send(.showLoading(true, true))
            defer {
                actionSubject.send(.showLoading(false, true))
                isFetchingData = false
            }
            let result = await communityUseCase.deletePost(postId: postId)
            switch result {
            case .success(_):
                actionSubject.send(.deletePost)
            case .failure(let failure):
                handleError(failure)
            }
        }
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
            actionSubject.send(.showLoading(true, false))
            defer { actionSubject.send(.showLoading(false, false)) }
            let result = await communityUseCase.fetchPostDetail(postId: postId)
            switch result {
            case .success(let success):
                post = success
                detail = CommunityPostDetail(post: post)
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

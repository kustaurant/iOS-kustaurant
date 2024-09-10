//
//  RestaurantDetailViewModel.swift
//  Kustaurant
//
//  Created by 류연수 on 8/12/24.
//

import UIKit
import Combine

struct RestaurantDetailViewModelActions {
    let pop: () -> Void
    let showEvaluateScene: () -> Void
    let showSearchScene: () -> Void
}

enum RestaurantDetailTabType: Int {
    case menu = 0
    case review
    
    init?(rawValue: Int) {
        if Self.menu.rawValue == rawValue {
            self = .menu
            return
        }
        if Self.review.rawValue == rawValue {
            self = .review
            return
        }
        return nil
    }
}

extension RestaurantDetailViewModel {
    
    enum State {
        case initial
        case fetch
        case didTab(at: RestaurantDetailTabType)
        case didTapEvaluationButton
        case didTapBackButton
        case didTapSearchButton
        case didTaplikeCommentButton(commentId: Int)
        case didTapDislikeCommentButton(commentId: Int)
        case didTapReportComment(commentId: Int)
        case didTapDeleteComment(commentId: Int)
        case didTapCommentButton(commentId: Int)
        case didTapSendButtonInAccessory(payload: CommentPayload)
        case didTapFavoriteButton
    }
    
    enum Action {
        case didFetchItems
        case didFetchHeaderImage(UIImage)
        case didFetchReviews
        case didFetchEvaluation(isFavorite: Bool, evaluationCount: Int)
        case didChangeTabType
        case loginStatus(LoginStatus)
        case didSuccessLikeOrDisLikeButton(commentId: Int, likeCount: Int, dislikeCount: Int, likeStatus: CommentLikeStatus)
        case showAlert(payload: AlertPayload)
        case showKeyboard(commentId: Int)
        case removeComment
        case addComment
        case toggleFavorite(Bool)
    }
}

final class RestaurantDetailViewModel {
    
    private(set) var restaurantId: Int
    private(set) var detail: RestaurantDetail?
    
    private let repository: any RestaurantDetailRepository
    private let authRepository: any AuthRepository
    private let actions: RestaurantDetailViewModelActions
    
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    @Published private(set) var loginStatus: LoginStatus = .notLoggedIn
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(
        restaurantId: Int,
        actions: RestaurantDetailViewModelActions,
        repository: any RestaurantDetailRepository,
        authRepository: any AuthRepository
    ) {
        self.restaurantId = restaurantId
        self.actions = actions
        self.repository = repository
        self.authRepository = authRepository
        bind()
    }
    
}

extension RestaurantDetailViewModel {
    
    private func bind() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                    
                case .fetch:
                    self?.fetch()
                    
                case .didTab(let type):
                    self?.changeTabType(as: type)
                    
                case .didTapEvaluationButton:
                    self?.actions.showEvaluateScene()
                    
                case .didTapBackButton:
                    self?.actions.pop()
                    
                case .didTapSearchButton:
                    self?.actions.showSearchScene()
                    
                case .didTaplikeCommentButton(let commentId):
                    self?.likeComment(commentId: commentId)
                    
                case .didTapDislikeCommentButton(let commentId):
                    self?.dislikeComment(commentId: commentId)
                    
                case .didTapReportComment(let commentId):
                    self?.reportComment(commentId: commentId)
                    
                case .didTapDeleteComment(let commentId):
                    self?.deleteComment(commentId: commentId)
                    
                case .didTapCommentButton(let commentId):
                    self?.showKeyboard(commentId: commentId)
                    
                case .didTapSendButtonInAccessory(let payload):
                    self?.addComment(payload: payload)
                    
                case .didTapFavoriteButton:
                    self?.toggleFavorite()
                }
            }
            .store(in: &cancellables)
    }
    
    private func fetch() {
        Task {
            let verified = await authRepository.verifyToken()
            loginStatus = verified ? LoginStatus.loggedIn : LoginStatus.notLoggedIn
            actionSubject.send(.loginStatus(loginStatus))
            
            detail = await repository.fetch()
            
            actionSubject.send(.didFetchItems)
            
            if 
                let isFavorite = self.detail?.isFavorite,
                let evaluationCount = self.detail?.evaluationCount
            {
                actionSubject.send(.didFetchEvaluation(isFavorite: isFavorite, evaluationCount: evaluationCount))
            }
            
            if let url: URL = .init(string: detail?.restaurantImageURLString ?? "") {
                ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
                    if let image {
                        self?.actionSubject.send(.didFetchHeaderImage(image))
                    }
                }
            }
            
            Task {
                let reviews = await repository.fetchReviews()
                var tabItems = detail?.tabItems
                tabItems?[.review] = reviews
                await detail?.updateTabItems(as: tabItems ?? [:])
                
                if detail?.tabType == .review {
                    actionSubject.send(.didFetchReviews)
                }
            }
        }
    }
    
    private func changeTabType(as type: RestaurantDetailTabType) {
        Task {
            guard detail?.tabType != type else { return }
            
            await detail?.updateTabType(as: type)
            
            actionSubject.send(.didChangeTabType)
        }
    }
    
}

// MARK: Comment
extension RestaurantDetailViewModel {
    
    private func likeComment(commentId: Int) {
        Task {
            let result = await repository.likeComment(restaurantId: restaurantId, commentId: commentId)
            await detail?.likeOrDislikeComment(commentId: commentId, likeStatus: .liked)
            await MainActor.run {
                switch result {
                case .success(let data):
                    actionSubject.send(
                        .didSuccessLikeOrDisLikeButton(
                            commentId: commentId,
                            likeCount: data.commentLikeCount ?? 0,
                            dislikeCount: data.commentDislikeCount ?? 0,
                            likeStatus: data.commentLikeStatus ?? .none)
                    )
                case .failure(let failure):
                    Logger.error("fail to like \(failure.localizedDescription)", category: .ui)
                    return
                }
            }
        }
    }
    
    private func dislikeComment(commentId: Int) {
        Task {
            let result = await repository.dislikeComment(restaurantId: restaurantId, commentId: commentId)
            await detail?.likeOrDislikeComment(commentId: commentId, likeStatus: .disliked)
            await MainActor.run {
                switch result {
                case .success(let data):
                    actionSubject.send(
                        .didSuccessLikeOrDisLikeButton(
                            commentId: commentId,
                            likeCount: data.commentLikeCount ?? 0,
                            dislikeCount: data.commentDislikeCount ?? 0,
                            likeStatus: data.commentLikeStatus ?? .none)
                    )
                case .failure(let failure):
                    Logger.error("fail to dislike \(failure.localizedDescription)", category: .ui)
                    return
                }
            }
        }
    }
    
    private func reportComment(commentId: Int) {
        actionSubject.send(.showAlert(payload: AlertPayload(title: "코멘트를 신고하시겠습니까?", subtitle: "", onConfirm: { [weak self] in
            guard let self = self else { return }
            Task {
                await self.repository.reportComment(restaurantId: self.restaurantId, commentId: commentId)
            }
        })))
    }
    
    private func deleteComment(commentId: Int) {
        actionSubject.send(.showAlert(payload: AlertPayload(title: "댓글을 삭제하시겠습니까?", subtitle: "", onConfirm: { [weak self] in
            guard let self = self else { return }
            Task {
                let deleted = await self.repository.deleteComment(restaurantId: self.restaurantId, commentId: commentId)
                if deleted {
                    await self.detail?.deleteComment(commentId: commentId)
                    await MainActor.run {
                        self.actionSubject.send(.removeComment)
                    }
                }
            }
        })))
    }
    
        
    private func addComment(payload: CommentPayload) {
        if let commentId = payload.commentId, let comment = payload.comment {
            Task {
                let result = await repository.addComment(restaurantId: restaurantId, commentId: commentId, comment: comment)
                switch result {
                case .success(let review):
                    await self.detail?.addComment(to: commentId, newComment: review)
                    await MainActor.run {
                        self.actionSubject.send(.addComment)
                    }
                case .failure:
                    return
                }
            }
        }
    }
}

// MARK: Accessory
extension RestaurantDetailViewModel {
    
    private func showKeyboard(commentId: Int) {
        actionSubject.send(.showKeyboard(commentId: commentId))
    }
    
    private func toggleFavorite() {
        Task {
            let result = await repository.toggleFavorite(restaurantId: self.restaurantId)
            await MainActor.run {
                switch result {
                case .success(let isFavorite):
                    actionSubject.send(.toggleFavorite(isFavorite))
                case .failure:
                    return
                }
            }
        }
    }
}

//
//  CommunityPostDetailViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Combine

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
        case initial, touchLikeButton
    }
    
    enum Action {
        case showLoading(Bool), touchLikeButton
    }
}

final class DefaultCommunityPostDetailViewModel: CommunityPostDetailViewModel {
    // Input
    @Published var state: State = .initial
    
    // Output
    let post: CommunityPostDTO
    let detail: CommunityPostDetail
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
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
                case .touchLikeButton:
                    self?.updateLikeButton()
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
    
    private func updateLikeButton() {
        guard !isFetchingData,
              let postId = post.postId
        else { return }
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

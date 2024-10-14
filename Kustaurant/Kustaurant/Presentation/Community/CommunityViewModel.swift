//
//  CommunityViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/13/24.
//

import Foundation
import Combine

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
        case initial, fetchPosts
    }
    enum Action {
        case showLoading(Bool), didFetchPosts
    }
}

final class DefaultCommunityViewModel: CommunityViewModel {
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<DefaultCommunityViewModel.Action, Never> = .init()
    var actionPublisher: AnyPublisher<DefaultCommunityViewModel.Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var posts: [CommunityPostDTO] = []
    
    private var currentPage = 0
    private var currentCategory: CommunityPostCategory = .all
    private var currentSortType: CommunityPostSortType = .popular
    private var isFetching = false {
        didSet {
            Task { @MainActor in
                actionSubject.send(.showLoading(isFetching))
            }
        }
    }
    
    private let communityUseCase: CommunityUseCases
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization
    init(communityUseCase: CommunityUseCases) {
        self.communityUseCase = communityUseCase
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
                case .fetchPosts:
                    self?.fetchPosts()
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
    
    private func fetchPosts() {
        guard !isFetching else { return }
        isFetching = true
        Task {
            defer { isFetching = false }
            let result = await communityUseCase.fetchPosts(category: currentCategory, page: currentPage, sort: currentSortType)
            switch result {
            case .success(let success):
                currentPage += 1
                posts = success
                actionSubject.send(.didFetchPosts)
            case .failure(let failure):
                handleError(failure)
            }
        }
    }
}

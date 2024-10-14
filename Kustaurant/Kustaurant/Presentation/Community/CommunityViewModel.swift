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
}

typealias CommunityViewModel = CommunityViewModelInput & CommunityViewModelOutput

extension DefaultCommunityViewModel {
    enum State {
        case initial, fetchPosts
    }
}

final class DefaultCommunityViewModel: CommunityViewModel {
    @Published var state: State = .initial
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
    private func fetchPosts() {
        Task {
            let result = await communityUseCase.fetchPosts(category: .all, page: 0, sort: .popular)
            switch result {
            case .success(let success):
                success.forEach {
                    print("====================")
                    print($0)
                }
            case .failure(let failure):
                Logger.error("커뮤니티 목록 Fetch Error : \(failure.localizedDescription)", category: .network)
            }
        }
    }
}

//
//  CommunityPostDetailViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import Combine

protocol CommunityPostDetailViewModelInput {}
protocol CommunityPostDetailViewModelOutput {
    var post: CommunityPostDTO {get}
}

typealias CommunityPostDetailViewModel = CommunityPostDetailViewModelInput & CommunityPostDetailViewModelOutput


extension DefaultCommunityPostDetailViewModel {
    enum State {
        case initial
    }
}

final class DefaultCommunityPostDetailViewModel: CommunityPostDetailViewModel {
    @Published var state: State = .initial
    
    let post: CommunityPostDTO
    private let communityUseCase: CommunityUseCases
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization
    init(
        post: CommunityPostDTO,
        communityUseCase: CommunityUseCases
    ) {
        self.communityUseCase = communityUseCase
        self.post = post
        bindState()
    }
}

extension DefaultCommunityPostDetailViewModel {
    private func bindState() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                }
            }
            .store(in: &cancellables)
    }
}

extension DefaultCommunityPostDetailViewModel {
    
}

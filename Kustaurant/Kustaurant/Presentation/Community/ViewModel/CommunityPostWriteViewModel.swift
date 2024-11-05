//
//  CommunityPostWriteViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import Foundation
import Combine

protocol CommunityPostWriteViewModelInput {
    func process(_ state: DefaultCommunityPostWriteViewModel.State)
}
protocol CommunityPostWriteViewModelOutput {}

typealias CommunityPostWriteViewModel = CommunityPostWriteViewModelInput & CommunityPostWriteViewModelOutput

extension DefaultCommunityPostWriteViewModel {
    enum State {
        case initial, changeCategory(CommunityPostCategory)
    }
}

final class DefaultCommunityPostWriteViewModel: CommunityPostWriteViewModel {
    @Published private var state: State = .initial
    private let communityUseCase: CommunityUseCases
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Initialization
    init(communityUseCase: CommunityUseCases) {
        self.communityUseCase = communityUseCase
        bindState()
    }
    
    // Input
    func process(_ state: State) {
        self.state = state
    }
}

extension DefaultCommunityPostWriteViewModel {
    private func bindState() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                case .changeCategory(let category):
                    self?.changeCategory(category)
                }
            }
            .store(in: &cancellables)
    }
}

extension DefaultCommunityPostWriteViewModel {
    private func changeCategory(_ category: CommunityPostCategory) {
        Logger.info(category.rawValue)
    }
}

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
protocol CommunityPostWriteViewModelOutput {
    var actionPublisher: AnyPublisher<DefaultCommunityPostWriteViewModel.Action, Never> { get }
}

typealias CommunityPostWriteViewModel = CommunityPostWriteViewModelInput & CommunityPostWriteViewModelOutput

extension DefaultCommunityPostWriteViewModel {
    enum State {
        case initial, changeCategory(CommunityPostCategory), updateTitle(String), updateContent(String)
    }
    enum Action {
        case updateCategory(CommunityPostCategory), changeStateDoneButton(Bool)
    }
}

final class DefaultCommunityPostWriteViewModel: CommunityPostWriteViewModel {
    @Published private var state: State = .initial
    private let communityUseCase: CommunityUseCases
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    private let writeData: CommunityPostWriteData = .init()
    
    // Output
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
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
                case .updateTitle(let title):
                    self?.updateTitle(title)
                case .updateContent(let content):
                    self?.updateContent(content)
                }
            }
            .store(in: &cancellables)
    }
}

extension DefaultCommunityPostWriteViewModel {
    private func changeCategory(_ category: CommunityPostCategory) {
        Task {
            await writeData.updateCategory(category)
            actionSubject.send(.updateCategory(category))
            await actionSubject.send(.changeStateDoneButton(writeData.isComplete))
        }
    }
    
    private func updateTitle(_ title: String) {
        Task {
            await writeData.updateTitle(title)
            await actionSubject.send(.changeStateDoneButton(writeData.isComplete))
        }
    }
    
    private func updateContent(_ content: String) {
        Task {
            await writeData.updateContent(content)
            await actionSubject.send(.changeStateDoneButton(writeData.isComplete))
        }
    }
}

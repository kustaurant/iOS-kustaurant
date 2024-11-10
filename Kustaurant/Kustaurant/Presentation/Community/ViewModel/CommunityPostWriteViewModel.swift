//
//  CommunityPostWriteViewModel.swift
//  Kustaurant
//
//  Created by 송우진 on 11/5/24.
//

import Foundation
import Combine

struct CommunityPostWriteViewModelActions {
    let pop: () -> Void
}

protocol CommunityPostWriteViewModelInput {
    func process(_ state: DefaultCommunityPostWriteViewModel.State)
}
protocol CommunityPostWriteViewModelOutput {
    var actionPublisher: AnyPublisher<DefaultCommunityPostWriteViewModel.Action, Never> { get }
}

typealias CommunityPostWriteViewModel = CommunityPostWriteViewModelInput & CommunityPostWriteViewModelOutput

extension DefaultCommunityPostWriteViewModel {
    enum State {
        case initial, changeCategory(CommunityPostCategory), updateTitle(String), updateContent(String), updateImageData(Data?),tappedDoneButton
    }
    enum Action {
        case showLoading(Bool), updateCategory(CommunityPostCategory), changeStateDoneButton(Bool), didCreatePost, showAlert(payload: AlertPayload)
    }
}

final class DefaultCommunityPostWriteViewModel: CommunityPostWriteViewModel {
    @Published private var state: State = .initial
    private let communityUseCase: CommunityUseCases
    private let actions: CommunityPostWriteViewModelActions
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellables: Set<AnyCancellable> = .init()
    private let writeData: CommunityPostWriteData = .init()
    
    // Output
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Initialization
    init(
        communityUseCase: CommunityUseCases,
        actions: CommunityPostWriteViewModelActions
    ) {
        self.communityUseCase = communityUseCase
        self.actions = actions
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
                case .tappedDoneButton:
                    self?.createPost()
                case .updateImageData(let imageData):
                    self?.updateImageData(imageData)
                }
            }
            .store(in: &cancellables)
    }
}

extension DefaultCommunityPostWriteViewModel {
    private func createPost() {
        Task {
            actionSubject.send(.showLoading(true))
            guard await writeData.isComplete else { return }
            do {
                if await writeData.imageData != nil {
                    let uploadImageFile = try await communityUseCase.uploadImage(writeData)
                    await writeData.updateImageFile(uploadImageFile.imgUrl)
                }
                let _ = try await communityUseCase.createPost(writeData)
                actionSubject.send(.showLoading(false))
                actionSubject.send(.didCreatePost)
                actionSubject.send(.showAlert(payload: AlertPayload(
                    title: "게시글 작성 완료",
                    subtitle: "",
                    onConfirm: { [weak self] in
                        self?.popAction()
                    }
                )))
            } catch {
                actionSubject.send(.showLoading(false))
                actionSubject.send(.showAlert(payload: AlertPayload(
                    title: "게시글 작성 실패",
                    subtitle: "다시 시도해주세요.",
                    onConfirm: nil)))
            }
        }
    }
    
    private func popAction() {
        Task { @MainActor in
            actions.pop()
        }
    }
    
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
    
    private func updateImageData(_ data: Data?) {
        Task {
            await writeData.updateImageData(data)
        }
    }
}
